//
//  RecordWeightViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase

//enum Weekday {
//    case Monday
//    case Tuesday
//}
//
//struct dateComponent {
//    let weekday: Weekday
//    
//    init(data: Data) {
//        <#statements#>
//    }
//}

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
            
            // Add a new document with a generated id
            var ref: DocumentReference? = nil
            ref = weightRef.addDocument(data: [
                "weight": weight as Any,
                "created_time": time
                ], completion: { (error) in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document added with ID: \(String(describing: ref?.documentID))")
                    }
            })
            
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
        } else {
            confirmBtn.isEnabled = false
        }
        
        return true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        if textField.text == "" {
            confirmBtn.isEnabled = false
        }
        
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
