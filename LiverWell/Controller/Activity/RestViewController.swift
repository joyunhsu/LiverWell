//
//  RestViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/12.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class RestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.navigationController?.popViewController(animated: false)
        })

    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//            self.navigationController?.popViewController(animated: false)
//        })
//
//    }

}
