//
//  SignUpFourthViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/28.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase
import TTTAttributedLabel

class SignUpFourthViewController: UIViewController, UITextFieldDelegate, TTTAttributedLabelDelegate {

    @IBOutlet weak var expectWeightTextfield: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var attributedLabel: TTTAttributedLabel!
    
    var signupEmail: String?
    
    var signupPassword: String?
    
    var userName: String?
    
    var currentWeight: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expectWeightTextfield.delegate = self
        
        startBtn.isEnabled = false
        startBtn.backgroundColor = .B3
        
        setup()
        
    }
    
    private func setup() {
        
        attributedLabel.numberOfLines = 0
        let strPP = "隱私權條款"
        let string = "點擊開始的同時，表示您同意 Liverwell 的\(strPP)"
        let nsString = string as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        
        let fullAttributedString = NSAttributedString(string:string, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
            ])
        attributedLabel.textAlignment = .center
        attributedLabel.attributedText = fullAttributedString
        
//        let rangeTC = nsString.range(of: strTC)
        let rangePP = nsString.range(of: strPP)
        
        let ppLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.B1!.cgColor,
            NSAttributedString.Key.underlineStyle.rawValue: false
        ]
        let ppActiveLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.B1!.cgColor,
            NSAttributedString.Key.underlineStyle.rawValue: false
        ]
        
        attributedLabel.activeLinkAttributes = ppActiveLinkAttributes
        attributedLabel.linkAttributes = ppLinkAttributes
        
//        let urlTC = URL(string: "action://TC")!
        let urlPP = URL(string: "https://www.joyunhsu.com/privacy-policy")!
//        attributedLable.addLink(to: urlTC, with: rangeTC)
        attributedLabel.addLink(to: urlPP, with: rangePP)
        
        attributedLabel.textColor = UIColor.lightGray
        attributedLabel.delegate = self
        
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == "action://TC" {
            print("TC click")
        } else if url.absoluteString == "https://www.joyunhsu.com/privacy-policy" {
            print("PP click")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
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
            startBtn.backgroundColor = .Orange
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
