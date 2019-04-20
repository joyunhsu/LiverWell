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
    
    @IBOutlet weak var todayStatusView: UIView!
    
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
        
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        
        let renderedImage = renderer.image { (UIGraphicsRendererContext) in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        
        // Image to share
        let image = renderedImage
        
        // set up activity view controller
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
