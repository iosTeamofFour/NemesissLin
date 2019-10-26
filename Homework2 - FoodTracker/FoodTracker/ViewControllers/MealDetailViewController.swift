//
//  MealDetailViewController.swift
//  ElegantLogin
//
//  Created by NemesissLin on 2019/10/15.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var Save: UIBarButtonItem!
    
    @IBOutlet weak var Cancel: UIBarButtonItem!
    @IBOutlet weak var MealTitle: UITextField!
    @IBOutlet weak var MealImage: UIImageView!

    
    
    var MealInstance : Meal? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 如果进入的是编辑模式，那么加载原有数据.
        if let meal = MealInstance {
            MealTitle.text = meal.Name
            MealImage.image = meal.Image
            
            // 处理左上角返回按钮
            navigationItem.leftBarButtonItems?.removeAll()
            navigationController?.navigationBar.topItem?.title = "返回"
        }
    }
    @IBAction func OnSelectImage(_ sender: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("没选到什么图片，退出.")
            return
        }
        
        MealImage.image = pickedImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem , button == Save else {
            print("点击了取消按钮，放弃保存.")
            MealInstance = nil
            return
        }
        
        MealInstance = Meal.init(Image: MealImage.image ?? UIImage(named: "Meal-0")!, Name: MealTitle.text ?? "", Rating: 4)
    }
}
