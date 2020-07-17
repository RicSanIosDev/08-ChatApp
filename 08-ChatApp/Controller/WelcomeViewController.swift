//
//  ViewController.swift
//  08-ChatApp
//
//  Created by Ricardo Sanchez on 7/15/20.
//  Copyright © 2020 Ricardo Sanchez. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SVProgressHUD.show()
        if Auth.auth().currentUser != nil {
            SVProgressHUD.dismiss(withDelay: 0.5)
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }else {
            SVProgressHUD.dismiss()
        }
    }


}

