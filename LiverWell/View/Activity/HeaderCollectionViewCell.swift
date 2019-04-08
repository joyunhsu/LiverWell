//
//  HeaderCollectionViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var crossImage: UIImageView!
    
    @IBOutlet weak var firstLineLabel: UILabel!
    
    @IBOutlet weak var secondLineLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var roundCornerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    func layoutCell(firstLine: String, secondLine: String, caption: String, crossImage: UIImage, corner: UIRectCorner) {
        
        self.crossImage.image = crossImage
        
        firstLineLabel.text = firstLine
        
        secondLineLabel.text = secondLine
        
        captionLabel.text = caption
        
        roundCornerView.roundCorners(corner, radius: 50)
        
    }

}
