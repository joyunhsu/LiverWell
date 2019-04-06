//
//  ActivityViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/2.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var firstCollectionView: UICollectionView!
    
    @IBOutlet weak var secondCollectionView: UICollectionView!
    
    let manager = ActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerNib = UINib(nibName: "ActivityCollectionReusableView", bundle: nil)
        
        firstCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ActivityCollectionReusableView")
        
        secondCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ActivityCollectionReusableView")
        
        let cellNib = UINib(nibName: "ActivityCollectionViewCell", bundle: nil)
        
        firstCollectionView.register(cellNib, forCellWithReuseIdentifier: "ActivityCollectionViewCell")
        
        secondCollectionView.register(cellNib, forCellWithReuseIdentifier: "ActivityCollectionViewCell")
        
        self.navigationController?.isNavigationBarHidden = true

        
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case firstCollectionView: return manager.groups[0].items.count
            
        case secondCollectionView: return manager.groups[1].items.count
            
        default: return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == firstCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCell", for: indexPath)
            
            guard let trainCell = cell as? ActivityCollectionViewCell else { return cell }
            
            let trainItems = manager.groups[0].items[indexPath.row]
            
            trainCell.layoutView(title: trainItems.title, image: trainItems.image)
            
            return trainCell
            
        } else if collectionView == secondCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCell", for: indexPath)
            
            guard let stretchCell = cell as? ActivityCollectionViewCell else { return cell }
            
            let stretchItems = manager.groups[1].items[indexPath.row]
            
            stretchCell.layoutView(title: stretchItems.title, image: stretchItems.image)
            
            return stretchCell
            
        }
        
        return UICollectionViewCell()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ActivityCollectionReusableView", for: indexPath) as! ActivityCollectionReusableView
            
            headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 166)
            
            return headerView
            
        } else {
            
            return UICollectionReusableView()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == firstCollectionView {
            
            performSegue(withIdentifier: "setupTrain", sender: self)
            
        } else {
            
            performSegue(withIdentifier: "setupStretch", sender: self)
            
        }
        
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Activity", bundle: nil)
//        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ActivitySetupViewController") as! ActivitySetupViewController
//        self.navigationController?.present(desVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TrainSetupViewController {
            var indexPath = self.firstCollectionView.indexPathsForSelectedItems?.first
//            let itemNumber: Int = indexPath!.item
            
            let passItem = manager.groups[1].items[indexPath!.item]
            
//            stretchCell.layoutView(title: stretchItems.title, image: stretchItems.image)
            
            destination.navTitle = passItem.title
            print(passItem.title)
        }
    }

}

extension ActivityViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
            
        case firstCollectionView: return CGSize(width: firstCollectionView.bounds.width / 2.0, height: 152.0)
            
        default: return CGSize(width: secondCollectionView.bounds.width / 2.0, height: 152.0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 26.0
    }
    
}
