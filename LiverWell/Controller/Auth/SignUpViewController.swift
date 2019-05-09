//
//  SIgnUpFirstViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/27.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase
import TTTAttributedLabel

class SignUpViewController: STBaseViewController, UITextFieldDelegate, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var signupEmailTextField: UITextField!
    
    @IBOutlet weak var signupPasswordTextfield: UITextField!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var attributedLabel: TTTAttributedLabel!
    
    var userName: String?
    
    var currentWeight: String?
    
    var expectedWeight: String?
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        
        if self.signupEmailTextField.text == "" || self.signupPasswordTextfield.text == "" {
            self.showMsg("請輸入email和密碼")
            return
        }
        
        // 建立帳號
        Auth.auth().createUser(
            withEmail: signupEmailTextField.text!,
            password: signupPasswordTextfield.text!
        ) { (user, error) in
            
            // 註冊失敗
            if error != nil {
                self.showMsg((error?.localizedDescription)!)
                return
            }
            
            // 註冊成功並顯示已登入
            self.showMsg("已登入")
            
            self.createUserDocument()
            
            self.createUserDocument()
            
        }
        
    }
    
    private func createUserDocument() {
        guard let userName = userName else { return }
        
//        let timestamp = NSDate().timeIntervalSince1970
//        let myTimeInterval = TimeInterval(timestamp)
//        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        let today = Date() //.timeIntervalSince1970
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日"
        let convertedDate = dateFormatter.string(from: today)
        
        let user = Auth.auth().currentUser
        
        let expectedWeightDouble = Double(expectedWeight!)

        let initialWeightDouble = Double(currentWeight!)!
        
        if let user = user {

            let uid = user.uid

            let userName = userName

            // 創建以用戶UID為名的document
            AppDelegate.db.collection("users").document(uid).setData([
                "name": userName,
                "initial_weight": expectedWeightDouble,
                "expected_weight": initialWeightDouble,
                "signup_time": today
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")

                    self.addInitialWeight(uid: uid, convertedDate: convertedDate, time: today)
                }
            }

        }
    }
    
    private func addInitialWeight(uid: String, convertedDate: String, time: Date) {
        
        AppDelegate.db.collection("users").document(uid).collection("weight").document(convertedDate).setData(
            [
                "weight": Double(currentWeight!),
                "created_time": time
        ]) { (err) in
            if let err = err {
                print("Error add initial weight to document: \(err)")
            } else {
                print("Add initial weight to document successfully")
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupPasswordTextfield.delegate = self
        
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
            NSAttributedString.Key.foregroundColor: UIColor.B1!.cgColor,
            ])
        attributedLabel.textAlignment = .center
        attributedLabel.attributedText = fullAttributedString
        
        let rangePP = nsString.range(of: strPP)
        
        let ppLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.Orange!.cgColor,
            NSAttributedString.Key.underlineStyle.rawValue: false
        ]
        let ppActiveLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.Orange!.cgColor,
            NSAttributedString.Key.underlineStyle.rawValue: false
        ]
        
        attributedLabel.activeLinkAttributes = ppActiveLinkAttributes
        attributedLabel.linkAttributes = ppLinkAttributes
        
        let urlPP = URL(string: "https://www.joyunhsu.com/privacy-policy")!

        attributedLabel.addLink(to: urlPP, with: rangePP)
        
        attributedLabel.textColor = UIColor.lightGray
        attributedLabel.delegate = self
        
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == "https://www.joyunhsu.com/privacy-policy" {
            print("PP click")
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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

}
