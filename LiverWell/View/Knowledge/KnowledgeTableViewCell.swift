//
//  KnowledgeTableViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class KnowledgeTableViewCell: UITableViewCell {
    
    var isMarked: Bool = false
    
    @IBOutlet weak var bookMarkBtn: UIButton!
    
    @IBAction func bookMarkBtnPressed(_ sender: UIButton) {
        
        isMarked = !isMarked
        
        if isMarked == true {
            bookMarkBtn.isSelected = true
        } else {
            bookMarkBtn.isSelected = false
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
