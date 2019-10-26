//
//  ViewController.swift
//  ElegantLogin
//
//  Created by NemesissLin on 24/09/2019.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let WelcomeI18NLabel : [String] = ["欢迎","歡迎","Welcome","ようこそ","Hello","Halo","你好","妳好","こんにちは"]
    
    @IBOutlet weak var WelcomeLabel: UILabel!
    @IBOutlet weak var WelcomeBackground: UIImageView!
    
    private var RunTimer = false
    
    private var ShowingLabel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Fade in background.
        
        UIView.animate(withDuration: 0.8, animations: {
            self.WelcomeBackground.alpha = 0.4
        })
        
        StartShowingWelcomeLabels()
    }

    
    private func StopTimer() {
        RunTimer = false
    }
    
    private func StartShowingWelcomeLabels() {
        RunTimer = true
        self.performSelector(inBackground: #selector(SetupTimer), with: self)
    }
    
    @objc private func SetupTimer() {
        while RunTimer {
            self.performSelector(onMainThread: #selector(UpdateLabel), with: self, waitUntilDone: true)
            sleep(3)
        }
    }
    
    @objc private func DimWelcomeLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.WelcomeLabel.alpha = 0
        }, completion: { _ in
            self.WelcomeLabel.text = self.WelcomeI18NLabel[self.ShowingLabel]
            self.ShowingLabel = (self.ShowingLabel + 1) % self.WelcomeI18NLabel.count
            self.ShowWelcomeLabel()
        })
    }
    
    @objc private func ShowWelcomeLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.WelcomeLabel.alpha = 1
        })
    }
    
    @objc private func UpdateLabel() {
        DimWelcomeLabel()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        Get the new view controller using segue.destinationViewController.
//        Pass the selected object to the new view controller.
    }
}

