//
//  ViewController.swift
//  LoginDemo
//
//  Created by 刘恒 on 2019/6/5.
//  Copyright © 2019 刘恒. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var btnAuthId: UIButton!
    @IBOutlet weak var vAythID: UIView!
    @IBOutlet weak var tfAccout: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnTypeChange: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if UserInfo.isLogged() {
            if LocalAuthManager.getBiometryType() == .touchID {
                btnAuthId.setBackgroundImage(UIImage(named: "TOUCHID"), for: .normal)
            }else if LocalAuthManager.getBiometryType() == .faceID{
                btnAuthId.setBackgroundImage(UIImage(named: "FACEID"), for: .normal)
            }else{
                btnAuthId.isHidden = true
            }
        }else{
            //隐藏生物识别
            btnTypeChange.isHidden = true
            self.view.exchangeSubview(at: 0, withSubviewAt: 1)
        }
    }

    @IBAction func didPressTypeChange(_ sender: Any) {
        self.view.exchangeSubview(at: 0, withSubviewAt: 1)
    }
    
    @IBAction func didPressPassword(_ sender: Any) {
        LoginManage.passWordLogin(userAccout: self.tfAccout.text!, password: self.tfPassword.text!) { (errorCode) in
            print("\(String(describing: errorCode))")
        }
    }
    
    @IBAction func didPressAuthLogin(_ sender: Any) {
        LoginManage.authLogin { (errorCode) in
            print("\(String(describing: errorCode))")
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

