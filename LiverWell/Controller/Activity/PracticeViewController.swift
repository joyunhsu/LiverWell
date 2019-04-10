//
//  PracticeViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class PracticeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var progressCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = progressCollectionView.dequeueReusableCell(withReuseIdentifier: "ProgressCell", for: indexPath)

        return cell

    }

}

extension PracticeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (self.view.frame.width - 6) / 4
        return CGSize(width: cellWidth, height: 5)
    }

}
