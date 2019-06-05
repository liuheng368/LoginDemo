//
//  RSAHandler.swift
//  LoginDemo
//
//  Created by 刘恒 on 2019/6/5.
//  Copyright © 2019 刘恒. All rights reserved.
//
// RSA公钥加密

import UIKit
import SwiftyRSA

class RSAHandler {
    public static func RSAEncryptedHandler(_ passWord:String) ->String? {
        do{
            //rsa加密
            let publicKeyRef = try PublicKey(base64Encoded: publicKey)
            let clear = try ClearMessage(string:passWord, using: .utf8)
            //PKCS1 / PKCS8 与秘钥生成时相同
            let encrypted = try clear.encrypted(with: publicKeyRef, padding: .PKCS1)
            let RSAPassWord = encrypted.base64String
            print("原密码\(RSADecryptedHandler(RSAPassWord) ?? "")")
            return RSAPassWord
        }catch{
            return nil
        }
    }
    
    public static func  RSADecryptedHandler(_ RSAPassWord:String) -> String? {
        do {
            //rsa解密
            let privateKeyRef = try PrivateKey(pemNamed: privateKey)
            let encrypted = try EncryptedMessage(base64Encoded: RSAPassWord)
            let clear = try encrypted.decrypted(with: privateKeyRef, padding: .PKCS1)
            let string = try clear.string(encoding: .utf8)
            return string
        } catch  {
            return nil
        }
    }
    
    
}

let publicKey = """
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCA4o3Fu8bXeoTP0PBdjqtMhCE0
qm5a03+dslcv6mIIS8YnYITE2e9K2wu+s1+adFyWY9RCWWX1yGIy4EN4he5b8Pt9
N+HRsNyM8eSfBW9a43U5MEKm47pvMdjWomwUj+8Jo2d5tAWXssgKLAkv3rY0Qkcv
eu4y5mYUd7F7sPbXIQIDAQAB
-----END PUBLIC KEY-----
"""

//私钥一般保存在服务器上
let privateKey = """
-----BEGIN RSA PRIVATE KEY-----
MIICWwIBAAKBgQCA4o3Fu8bXeoTP0PBdjqtMhCE0qm5a03+dslcv6mIIS8YnYITE
2e9K2wu+s1+adFyWY9RCWWX1yGIy4EN4he5b8Pt9N+HRsNyM8eSfBW9a43U5MEKm
47pvMdjWomwUj+8Jo2d5tAWXssgKLAkv3rY0Qkcveu4y5mYUd7F7sPbXIQIDAQAB
AoGACKYAg2s6nYz1dTMns0TL49eImY3Hgpq8mSq1b7FXoLI3pWl0Sff3IbEZ1FMZ
sDXsseltqIIdNbqbiZ8Y3UaHcamlaN3B+aeIDOjDcd0t/m+IEg6M22jmYyYYpCpa
uqJsdjTG0x1LI9Z7gaNo5KI7K+p/WpOsZA+8VmZTkBgkzL0CQQCDupJ089zSM9vb
8dnUOy7ayDDHGfUiTXW/nbT5/wrgOhGAtr1/GBRRimQnOYnzUWN4GioNH5vIfagC
yS7aOwnbAkEA+nktyxapeWfMOUNH3Nyke/JFjmGb+pBEkhXmIEDQ9XqafwiGuMi8
CvMXJnw/B/LigXPXoiRfV3n3huW23HbJswJAGrHXdi3pJQvvVR4o15J6x0lkYSTI
gYATCZbLExJ1QMVjwKLHuhbGH1QdQbmuVAm9T5x1wx0Rs8qLHq1oej8WmwJAfQsu
L2t65B9Lt3K9V6fXfgFvdCuKwUZw1TWVk5iIOWUh6DWLfIjKR/UgI5h3pzI8nkAE
8O+ToYpEZtYbumibPQJAXaZvKYm0PO5aftLSH7e4lV9wT88eFBeIdBYtGGtOnNkC
B4PzyckHxkMfasYllshR59/GO6AW+S1mqQH19Tb9Bw==
-----END RSA PRIVATE KEY-----
"""
