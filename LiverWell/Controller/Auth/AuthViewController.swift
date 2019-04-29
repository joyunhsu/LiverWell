//
//  AuthViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: STBaseViewController {
    
    @IBOutlet weak var sloganLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sloganLabel.text = "每天15分鐘動一動，\n遠離脂肪肝！"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

}
