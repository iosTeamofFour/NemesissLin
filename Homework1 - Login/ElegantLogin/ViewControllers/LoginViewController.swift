//
//  LoginViewController.swift
//  ElegantLogin
//
//  Created by NemesissLin on 25/09/2019.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var LoginLabel: UILabel!
    
    @IBOutlet weak var InputAreaView: UIView!
    
    @IBOutlet weak var UserName: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    
    private var TextFieldAndLabelBinding  = Dictionary<UITextField,UILabel>()
    private var LabelOriginTransform = Dictionary<UILabel,CGAffineTransform>()
    
    private var ViewOriginalCenterY : CGFloat = 0
    private var ShownKeyboardSize : CGFloat = 0
    
    private var LastButtonWindowCoord : CGRect!
    private var InputAreaViewEndY : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserName.delegate = self
        Password.delegate = self
        TextFieldAndLabelBinding[UserName] = UserNameLabel
        TextFieldAndLabelBinding[Password] = PasswordLabel
        
        LabelOriginTransform[UserNameLabel] = UserNameLabel.transform
        LabelOriginTransform[PasswordLabel] = PasswordLabel.transform
        
        ViewOriginalCenterY = self.view.center.y
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.KeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.KeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        StartShowInputAreaAnimation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func RecordInputAreaLastViewPosition() {
        let LastButton = InputAreaView.subviews.last!
        let CurrentWindow = UIApplication.shared.delegate?.window!
        LastButtonWindowCoord = LastButton.convert(LastButton.bounds, to: CurrentWindow)
        InputAreaViewEndY = LastButtonWindowCoord.origin.y + LastButtonWindowCoord.height + 20
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func AdjustKeyboardOverlap() {
        print("AdjustKeyboardOverlap called.")
        let (_, Height) = UIUtils.GetScreenWHDP()
        let MaxAllowHeight = Height - ShownKeyboardSize
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let Delta = MaxAllowHeight - self.InputAreaViewEndY
        self.view.center.y = self.ViewOriginalCenterY + Delta
        CATransaction.commit()
        print("Adjust delta:\(Delta)")
    }
    
    @objc func KeyboardWillShow(notification:NSNotification) {
        print("KeyboardWillShow called.")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            ShownKeyboardSize != keyboardSize.height // Prevent fire twice, idk why.
        {
            ShownKeyboardSize = keyboardSize.height
            AdjustKeyboardOverlap()
        }
    }
    
    @objc func KeyboardWillHide(notification:NSNotification) {
        ShownKeyboardSize = 0
        
        CATransaction.begin()
        self.view.center.y = self.ViewOriginalCenterY
        CATransaction.commit()
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        SetBlurTextFieldBored(tf: textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        SetFocusTextFieldBored(tf: textField)
        return true
    }
    
    
    @IBAction func OnClickLoginButton(_ sender: UIButton) {
        let username = UserName.text!
        let password = Password.text!
        if (username as NSString).length > 0, password.elementsEqual("123456") {
            ChangeButtonTextAnimation(toText: "欢迎您, \(username)")
            InputAreaView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let storyboard = self.storyboard!
                let secretView = storyboard.instantiateViewController(withIdentifier: "Secret") as! SecretViewController
                secretView.LoginedUser = username
                self.present(secretView, animated: true, completion: nil)
            }
        }
        else {
            ChangeButtonTextAnimation(toText: "密码错误")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.ChangeButtonTextAnimation(toText: "登陆")
            })
        }
    }
    
    private func SetBlurTextFieldBored(tf : UITextField) {
        if (tf.text! as NSString).length > 0 {
            return
        }
        let label = TextFieldAndLabelBinding[tf]!
        let transform = LabelOriginTransform[label]!
        UIView.animate(withDuration: 0.5, animations: {
            label.transform = transform
        }, completion: nil)
    }
    
    private func SetFocusTextFieldBored(tf : UITextField) {
        if (tf.text! as NSString).length > 0 {
            return
        }
        let label = TextFieldAndLabelBinding[tf]!
        let transform = label.transform
        let down = transform.translatedBy(x: -22, y: -32)
        let scale = down.scaledBy(x: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5, animations: {
            label.transform = scale
        }, completion: nil)
    }
    
    private func ChangeButtonTextAnimation(toText : String) {
        let animation = InorderAnimation()
        animation.AddAnimation(animation: ExecuteAnimation(Duration: 0.1, Delay: 0, Options: .curveLinear, WhenComplete: {
            _ in self.LoginButton.setTitle(toText, for: UIControlState.normal)
        }, DoAnimation: {
            self.LoginButton.alpha = 0
        }))
        animation.AddAnimation(animation: ExecuteAnimation(Duration: 0.1, Delay: 0, Options: .curveLinear, WhenComplete: nil, DoAnimation: {
            self.LoginButton.alpha = 1
        }))
        animation.Begin()
    }
    
    @objc private func StartShowInputAreaAnimation() {
        let LoginLabelOriginTransform = self.LoginLabel.transform
        
        let (_, Height) = UIUtils.GetScreenWHDP()
        
        let LoginLabelOriginPos = self.LoginLabel.frame.origin
        let LoginLabelNewTransfrom = LoginLabelOriginTransform
            .translatedBy(x: InputAreaView.frame.minX - LoginLabelOriginPos.x, y: Height * 0.07 - LoginLabelOriginPos.y)
        
        let LoginLabelNewScaledTransform = LoginLabelNewTransfrom.scaledBy(x: 0.7, y: 0.7)
        let InputAreaNewTransform = InputAreaView.transform.translatedBy(x: 0, y: -60)
        
        let animationList = InorderAnimation()
        animationList.AddAnimation(animation: ExecuteAnimation(Duration: 0.8, Delay: 0.5, Options: .curveEaseInOut, WhenComplete: nil, DoAnimation: {
            self.LoginLabel.alpha = 1.0
            self.LoginLabel.transform = LoginLabelNewScaledTransform
        }))
        
        animationList.AddAnimation(animation: ExecuteAnimation(Duration: 0.8, Delay: 0, Options: .curveEaseInOut, WhenComplete: {
            _ in
            self.RecordInputAreaLastViewPosition()
        }, DoAnimation: {
            self.InputAreaView.alpha = 1.0
            self.InputAreaView.transform = InputAreaNewTransform
        }))
        
        animationList.Begin()
    }
}
