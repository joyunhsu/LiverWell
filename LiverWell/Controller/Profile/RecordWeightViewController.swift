//
//  RecordWeightViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class RecordWeightViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var reloadDataAfterUpdate: (() -> Void)?
    
    var weightDocumentID: String?
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日"
        let convertedDate = dateFormatter.string(from: today)
        
        guard let user = Auth.auth().currentUser else { return }

        guard let weightText = textField.text else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(user.uid).collection("weight")
        
        let weight = Double(weightText)
        
        if let weightDocumentID = weightDocumentID {
            
            // Update document without overwriting
            weightRef.document(weightDocumentID).updateData([
                "weight": weight
            ]) { (error) in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document succesfully updated")
                }
            }
            
        } else {
            
            let weightData: [String: Any] = [
                "weight": weight,
                "created_time": time
            ]
            
            weightRef.document(convertedDate).setData(weightData) { (err) in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Weight document successfully written!")
                }
            }
            
        }
        
        guard let closure = reloadDataAfterUpdate else { return }
        
        closure()
        
        dismiss(animated: true)
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = .G1
        } else {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = .B3
        }
        
        return true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
//        if textField.text == "" {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = .B3
//        }
        
        if weightDocumentID != nil {
            titleLabel.text = "修改體重"
        } else {
            titleLabel.text = "新增體重"
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        weightDocumentID = nil
    }

}
