//
//  KingFisherWrapper.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/18.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String, placeholder: UIImage? = nil) {
        
        let url = URL(string: urlString)
        
        self.kf.setImage(with: url, placeholder: placeholder)
        
    }
    
}
