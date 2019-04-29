//
//  SIgnUpFirstViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/27.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class SignUpFirstViewController: STBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signupEmailTextField: UITextField!
    
    @IBOutlet weak var signupPasswordTextfield: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBAction func nextBtnPressed(_ sender: UIButton) {
        
        if self.signupEmailTextField.text == "" || self.signupPasswordTextfield.text == "" {
            self.showMsg("請輸入email和密碼")
            return
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupPasswordTextfield.delegate = self
        
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .B3

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let desVC = segue.destination as? SignUpSecondViewController {
            desVC.signupEmail = signupEmailTextField.text
            desVC.signupPassword = signupPasswordTextfield.text
        }

    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            nextBtn.isEnabled = true
            nextBtn.backgroundColor = .B1
        } else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = .B3
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
