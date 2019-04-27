//
//  SignUpThirdViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/27.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class SignUpThirdViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var currentWeightTextfield: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var signupEmail: String?
    
    var signupPassword: String?
    
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeightTextfield.delegate = self
        
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .B3

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let desVC = segue.destination as? SignUpFourthViewController {
            desVC.signupEmail = signupEmail
            desVC.signupPassword = signupPassword
            desVC.userName = userName
            desVC.currentWeight = currentWeightTextfield.text!
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
            nextBtn.backgroundColor = .G1
        } else {
            nextBtn.isEnabled = false
            nextBtn.backgroundColor = .B3
        }
        
        return true
        
    }
    
}
