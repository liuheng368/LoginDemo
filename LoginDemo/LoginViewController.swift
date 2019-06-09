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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if LocalAuthManager.getBiometryType() == .touchID {
            btnAuthId.setBackgroundImage(UIImage(named: "TOUCHID"), for: .normal)
        }else if LocalAuthManager.getBiometryType() == .faceID{
           btnAuthId.setBackgroundImage(UIImage(named: "FACEID"), for: .normal)
        }else{
            btnAuthId.isHidden = true
        }
    }

    @IBAction func didPressTypeChange(_ sender: Any) {
        self.view.exchangeSubview(at: 0, withSubviewAt: 1)
    }
    
    @IBAction func didPressPassword(_ sender: Any) {
        LocalAuthManager.userLocalAuth("开启生物验证") {[weak self] (state, error) -> (Void) in
            guard let `self` = self else{return}
            if state == .success {
                UserInfo.setUserInfoModel(self.tfAccout.text!, accessToken: self.tfPassword.text!)
                self.loginSucess()
            }else{
                print("登录失败")
            }
        }
        loginSucess()
    }
    
    @IBAction func didPressAuthLogin(_ sender: Any) {
        LocalAuthManager.userLocalAuth("生物验证") {[weak self] (state, error) -> (Void) in
            guard let `self` = self else{return}
            if state == .success {
                self.loginSucess()
            }else{
                print("登录失败")
            }
        }
    }

    private func loginSucess() {
        let vcLogin = UIApplication.shared.keyWindow?.rootViewController
        let storyboard = UIStoryboard(name: "main", bundle: nil)
        let vcRoot = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.keyWindow?.rootViewController = vcRoot
        //手动释放登录页面
        vcLogin?.dismiss(animated: false, completion: nil)
    }
}

