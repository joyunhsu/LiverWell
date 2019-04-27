//
//  SignUpFourthViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/28.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase

class SignUpFourthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var expectWeightTextfield: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    
    var signupEmail: String?
    
    var signupPassword: String?
    
    var userName: String?
    
    var currentWeight: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expectWeightTextfield.delegate = self
        
        startBtn.isEnabled = false
        startBtn.backgroundColor = .B3
        
    }
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
        guard let signupEmail = signupEmail, let signupPassword = signupPassword else { return }
        
        // 建立帳號
        Auth.auth().createUser(
            withEmail: signupEmail,
            password: signupPassword
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
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            startBtn.isEnabled = true
            startBtn.backgroundColor = .G1
        } else {
            startBtn.isEnabled = false
            startBtn.backgroundColor = .B3
        }
        
        return true
        
    }
    
    func showMsg(_ message: String) {
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func createUserDocument() {
        
        guard let userName = userName else { return }
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            
            let uid = user.uid
            
            let userName = userName
            
            // 創建以用戶UID為名的document
            AppDelegate.db.collection("users").document(uid).setData([
                "name": userName,
                "current_weight": Double(currentWeight!),
                "expected_weight": Double(expectWeightTextfield.text!)
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }

}
