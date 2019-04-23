//
//  WeightEntryTableViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/10.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class WeightEntryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layoutView(date: String, weight: Double) {
        
        dateLabel.text = date
        
        weightLabel.text = "\(weight)Kg"
        
    }

}
