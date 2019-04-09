//
//  ActivityCollectionViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/2.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class ActivityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var workoutIcon: UIImageView!

    @IBOutlet weak var workoutLabel: UILabel!

    func layoutView(title: String, image: UIImage?) {

        workoutLabel.text = title

        workoutIcon.image = image

    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
