//
//  FirstViewController.swift
//  ElegantLogin
//
//  Created by NemesissLin on 2019/10/8.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("准备前往: \(segue.destination)")
    }
    
    @IBAction func unwindToFirstVC(_ unwindSegue: UIStoryboardSegue) {
        print("回到 \(unwindSegue.destination)")
    }
}
