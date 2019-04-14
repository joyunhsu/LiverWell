//
//  ShareViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/14.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet weak var todayStatusBtn: UIButton!
    
    @IBOutlet weak var weeklyStatusBtn: UIButton!
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
