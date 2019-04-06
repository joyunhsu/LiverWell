//
//  ActivitySetupViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class TrainSetupViewController: UIViewController {
    
    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
        
    }
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    
    var navTitle: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarItem.title = navTitle

    }
    
    


}
