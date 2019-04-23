//
//  RecordWeightViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase

class RecordWeightViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var reloadDataAfterUpdate: (() -> Void)?
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
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
        
        // Add a new document with a generated ID
//        var ref: DocumentReference? = nil
//        ref = AppDelegate.db.collection("users").addDocument(data: [
//            "weight": weight,
//            "created_time": time
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        guard let closure = reloadDataAfterUpdate else { return }
        
        closure()
        
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
