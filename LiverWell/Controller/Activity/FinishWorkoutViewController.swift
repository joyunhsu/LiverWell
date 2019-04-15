//
//  FinishWorkoutViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/12.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class FinishWorkoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(
            withIdentifier: String(describing: HomeViewController.self)
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//            self.navigationController?.pushViewController(homeVC, animated: true)
            self.navigationController?.show(homeVC, sender: true)
        })
    }

}
