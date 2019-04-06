//
//  KnowledgeViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class KnowledgeViewController: UIViewController {
    
    @IBOutlet weak var foodBtn: UIButton!
    
    @IBOutlet weak var workoutBtn: UIButton!
    
    @IBOutlet weak var liverBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupBtnView()
        
    }
    
    private func setupBtnView() {
        
        foodBtn.roundCorners(.allCorners, radius: 22)
        
        foodBtn.dropShadow()
        
        workoutBtn.dropShadow()
        
        liverBtn.dropShadow()
        
    }
    


}
