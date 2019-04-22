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
    
//    var weight: String?
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        let userRef = AppDelegate.db.collection("users").document(uid)
        
        guard let weight = textField.text else { return }
        // Update document without overwriting
        userRef.updateData([
            "weight" : weight,
            "created_time": time
        ]) { (error) in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document succesfully updated")
            }
        }
        
        print(weight)
        
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
        
        dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
