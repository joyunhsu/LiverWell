//
//  DetailKnowledgeViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class DetailKnowledgeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
