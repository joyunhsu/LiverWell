//
//  PieChartTableViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class PieChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    @IBOutlet weak var stretchLabel: UILabel!
    
    @IBOutlet weak var trainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(trainSum: Int, stretchSum: Int) {
        
        let totalSum = trainSum + stretchSum
        
        let trainProportion = lround(Double(trainSum * 100 / totalSum))
        
        let stretchProportion = 100 - trainProportion
        
        progressView.value = CGFloat(trainSum * 100 / totalSum)
        
        stretchLabel.text = "\(stretchProportion)%"
        
        trainLabel.text = "\(trainProportion)%"
    }

}
