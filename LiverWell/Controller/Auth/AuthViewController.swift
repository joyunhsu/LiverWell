//
//  AuthViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {
    
    @IBOutlet weak var signupEmailTextField: UITextField!
    
    @IBOutlet weak var signupPasswordTextfield: UITextField!
    
    @IBOutlet weak var signupNameTextfield: UITextField!
    
    @IBOutlet weak var loginEmailTextfield: UITextField!
    
    @IBOutlet weak var loginPasswordTextfield: UITextField!
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
        // email和密碼為必填欄位
        if self.signupEmailTextField.text == "" || self.signupPasswordTextfield.text == "" {
            self.showMsg("請輸入email和密碼")
            return
        }
        
        // 建立帳號
        Auth.auth().createUser(
        withEmail: self.signupEmailTextField.text!,
        password: self.signupPasswordTextfield.text!
        ) { (user, error) in
            
            // 註冊失敗
            if error != nil {
                self.showMsg((error?.localizedDescription)!)
                return
            }
            
            // 註冊成功並顯示已登入
            self.showMsg("已登入")
            
            self.createUserDocument()
            
        }
        
    }
    
    private func createUserDocument() {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            
            let userName = signupNameTextfield.text
            
            // 創建以用戶UID為名的document
            AppDelegate.db.collection("users").document(uid).setData([
                "name": userName
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
        
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        Auth.auth().signIn(
        withEmail: loginEmailTextfield.text!,
        password: loginPasswordTextfield.text!
        ) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Error", style: .cancel, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func showMsg(_ message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
