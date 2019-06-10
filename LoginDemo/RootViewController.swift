//
//  RootViewController.swift
//  LoginDemo
//
//  Created by 刘恒 on 2019/6/5.
//  Copyright © 2019 刘恒. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan
        // Do any additional setup after loading the view.
    }

    @IBAction func didPressLogout(_ sender: Any) {
        LogoutManage.logout()
    }

}
