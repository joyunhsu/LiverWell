//
//  FirstActivityInfoTableViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/7.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class FirstActivityInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func layoutView(title: String, description: String) {
        
        titleLabel.text = title
        
        descriptionLabel.text = description
        
    }

}
