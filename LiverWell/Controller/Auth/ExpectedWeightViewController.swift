//
//  SignUpFourthViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/28.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class ExpectedWeightViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var expectWeightTextfield: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var signupEmail: String?
    
    var signupPassword: String?
    
    var userName: String?
    
    var currentWeight: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expectWeightTextfield.delegate = self
        
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .B3
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let desVC = segue.destination as? SignUpViewController {
            desVC.userName = userName
            desVC.currentWeight = currentWeight
            desVC.expectedWeight = expectWeightTextfield.text!
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
            nextBtn.backgroundColor = .Orange
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
