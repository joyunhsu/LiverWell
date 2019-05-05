//
//  StretchPrepareViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/5/5.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
class StretchPrepareViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var repeatCollectionView: UICollectionView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    @IBOutlet weak var workoutImageView: UIImageView!
    
    @IBOutlet weak var soundBtn: UIButton!
    
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    var navTitle: String?
    
    var barTimer: Timer?
    
    var repeatTimer: Timer?
    
    var counter = 1
    
    var workoutArray: [WorkoutSet]?
    
    var workoutIndex = 0
    
    var repeatCountingText = [String]()
    
    var currentRepeat = 1
    
    var workoutMinutes: Float? = 5
    
    var currentTime: Float = 0.0 {
        
        didSet {
            print(currentTime)
        }
        
    }
    
    var soundIsOn: Bool = true // offIcon -> selected
    
    @IBAction func toggleSonudBtnPressed(_ sender: UIButton) {
        
        soundIsOn = !soundIsOn
        
        if soundIsOn == true {
            
//            doneAudioPlayer.volume = 1
//
//            countAudioPlayer.volume = 1
            
            soundBtn.isSelected = true // onIcon -> default
            
        } else {
            
//            doneAudioPlayer.volume = 0
//
//            countAudioPlayer.volume = 0
            
            soundBtn.isSelected = false
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navTitle
        
        viewHeightConstraint.constant = 240
        
        guard let workoutArray = workoutArray else { return }
        let currentWorkout = workoutArray[workoutIndex]
        workoutImageView.image = UIImage(named: currentWorkout.images[0])
        
        counter = workoutArray[workoutIndex].count
        countDownLabel.text = "00:\(String(format: "%02d", self.counter))"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            UIView.animate(withDuration: 5.5) {
                self.viewHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
            
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
            
            self.performSegue(withIdentifier: "startStretch", sender: self)
            
        })

    }
    
    @IBAction func unwindtoPrepare(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? StretchWorkoutViewController,
            let workoutMinutes = workoutMinutes {
            desVC.workoutMinutes = workoutMinutes
            desVC.workoutArray = workoutArray
            desVC.navTitle = navTitle
        }
        
        if let pauseVC = segue.destination as? PauseViewController {
            pauseVC.currentTime = self.currentTime
            pauseVC.maxTime = workoutMinutes!
            pauseVC.workoutArray = workoutArray
            pauseVC.workoutIndex = workoutIndex
        }
    }

}

extension StretchPrepareViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let workoutArray = workoutArray else { return 0 }
        
        return workoutArray[workoutIndex].workoutSetRepeat
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = repeatCollectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RepeatCollectionViewCell.self),
            for: indexPath
        )
        
        guard let repeatCell = cell as? RepeatCollectionViewCell else { return cell }
        
        var bgColorArray = [UIColor?]()
        var textColorArray = [UIColor?]()
        guard let workoutArray = workoutArray else { return cell }
        
        for _ in 0..<workoutArray[workoutIndex].workoutSetRepeat {
            let defaultViewColor = UIColor.B5
            bgColorArray.append(defaultViewColor)
            
            let defaultTextColor = UIColor.B1
            textColorArray.append(defaultTextColor)
        }
        
        for i in 0..<currentRepeat {
            let finishedViewColor = UIColor.G2
            bgColorArray[i] = finishedViewColor
            
            let finishedTextColor = UIColor.white
            textColorArray[i] = finishedTextColor
        }
        
        repeatCell.counterLabel.text = String(indexPath.item + 1)
        repeatCell.counterLabel.textColor = textColorArray[indexPath.item]
        repeatCell.cellBackground.backgroundColor = bgColorArray[indexPath.item]
        
        return repeatCell
    }
    
}

extension StretchPrepareViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        guard let workoutArray = workoutArray else { return CGSize() }
        let collectionViewWidth = repeatCollectionView.bounds.width
        let cellSpace = Int(collectionViewWidth) / workoutArray[workoutIndex].workoutSetRepeat
        return CGSize(width: cellSpace, height: 25)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }
    
}

