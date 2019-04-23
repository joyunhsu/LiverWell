//
//  RecordWeightViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase

class RecordWeightViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var reloadDataAfterUpdate: (() -> Void)?
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        guard let user = Auth.auth().currentUser else { return }
        
        let uid = user.uid

        guard let weightText = textField.text else { return }
        
        let weight = Double(weightText)
        
        // Add a new document with a generated id
        var ref: DocumentReference? = nil
        ref = AppDelegate.db.collection("users").document(uid).collection("weight").addDocument(data: [
            "weight": weight as Any,
            "created_time": time
            ], completion: { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: \(String(describing: ref?.documentID))")
                }
        })
        
        guard let closure = reloadDataAfterUpdate else { return }
        
        closure()
        
        dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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

    }

}
