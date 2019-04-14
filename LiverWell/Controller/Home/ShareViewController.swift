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
    
    @IBOutlet var statusBtns: [UIButton]!
    
    @IBAction func selectStatusBtnPressed(_ sender: UIButton) {
        
        for btn in statusBtns {
            
            btn.isSelected = false
            
        }
        
        sender.isSelected = true
        
        selectStatus(withTag: sender.tag)
        
    }
    
    func selectStatus(withTag: Int) {
        
    }
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
