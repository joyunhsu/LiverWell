//
//  WeekProgressCollectionViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/7.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class WeekProgressCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    @IBOutlet weak var completeImage: UIImageView!
    
    
}
