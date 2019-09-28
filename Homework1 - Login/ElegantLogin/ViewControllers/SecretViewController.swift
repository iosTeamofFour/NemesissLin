//
//  SecretViewController.swift
//  ElegantLogin
//
//  Created by NemesissLin on 28/09/2019.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class SecretViewController: UIViewController {
    var LoginedUser : String = ""
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    @IBOutlet weak var TextList: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrepareTexts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ShowTextAnimation()
    }
    private func PrepareTexts() {
        let Texts = ["\(LoginedUser), this is secret area.","So hard working with iOS animation."]
        for text in Texts {
            let label = UILabel.init()
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.alpha = 0.0
            TextList.addArrangedSubview(label)
        }
    }
    
    private func ShowTextAnimation() {
        let animation = InorderAnimation()
        for view in self.TextList.subviews {
            animation.AddAnimation(animation: ExecuteAnimation(Duration: 0.75, Delay: 0, Options: .curveLinear, WhenComplete: nil, DoAnimation: {
                view.alpha = 1.0
            }))
        }
        animation.AddAnimation(animation:ExecuteAnimation(Duration: 0.75, Delay: 0, Options: .curveLinear, WhenComplete: nil, DoAnimation: {
            self.BackgroundImage.alpha = 0.3
            self.BackgroundImage.transform = self.BackgroundImage.transform.translatedBy(x: 0, y: -20)
        }))
        animation.Begin()
    }
}
