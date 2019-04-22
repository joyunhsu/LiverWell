//
//  SettingViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingViewController: UIViewController {
    
    @IBAction func logOutBtnPressed(_ sender: UIButton) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                dismiss(animated: true, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
