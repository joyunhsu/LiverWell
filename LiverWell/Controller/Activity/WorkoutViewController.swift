//
//  WorkoutViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

struct Workout {
    
    let title: String
    
    let info: String
    
    let totalRepeat: Int
    
    let totalCount: Int
    
    let perDuration: TimeInterval
    
    let workoutImage: [UIImage]
    
}

// swiftlint:disable identifier_name
class WorkoutViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var repeatCollectionView: UICollectionView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    @IBOutlet weak var workoutImageView: UIImageView!
    
    @IBOutlet weak var soundBtn: UIButton!
    
    var barTimer: Timer?
    
    var repeatTimer: Timer?
    
    var startTime = 0
    
    var counter = 1
    
    var workoutSet = [
        Workout(
            title: "看電視順便做",
            info: "轉到手臂有明顯緊繃感為止",
            totalRepeat: 3,
            totalCount: 3,
            perDuration: 6,
            workoutImage: [#imageLiteral(resourceName: "01毛巾捲腹運動1.png"), #imageLiteral(resourceName: "01毛巾捲腹運動2.png")]
        ),
        Workout(
            title: "預防腰痛",
            info: "轉到手臂有明顯緊繃感為止",
            totalRepeat: 2,
            totalCount: 5,
            perDuration: 4,
            workoutImage: [#imageLiteral(resourceName: "02反向高抬腿1.png"), #imageLiteral(resourceName: "02反向高抬腿2.png")]
        )
    ]
    
    var workoutIndex = 0
    
    var repeatCountingText = [String]()
    
    var currentRepeat = 1
    
    var workoutMinutes: Float?
    
    var currentTIme: Float = 0.0
    
    var soundIsOn: Bool = true
    
    @IBAction func toggleSonudBtnPressed(_ sender: UIButton) {
        
        soundIsOn = !soundIsOn
        
        if soundIsOn == true {
            soundBtn.isSelected = false
        } else {
            soundBtn.isSelected = true
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        changeTitleAndRepeatText()
        
        updateBarProgress()
        
//        barProgressView.setProgress(currentTIme, animated: false)
        let currentWorkout = workoutSet[workoutIndex]
        workoutImageView.animationImages = [
            currentWorkout.workoutImage[0],
            currentWorkout.workoutImage[1]
        ]
        
        workoutImageView.animationDuration = currentWorkout.perDuration
        workoutImageView.startAnimating()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        repeatTimer?.invalidate()
        barTimer?.invalidate()
        repeatCountingText = [String]()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let workoutMinutes = workoutMinutes else { return }
        let maxTime = workoutMinutes * 60.0
        if let destination = segue.destination as? RestViewController {
            destination.currentTime = self.currentTIme
            destination.maxTime = maxTime
        }
    }
    
    private func changeTitleAndRepeatText() {
        
        let currentWorkout = workoutSet[workoutIndex]
        
        workoutTitleLabel.text = currentWorkout.title
        infoLabel.text = currentWorkout.info
        
        counter = 1
        repeatLabel.text = "\(self.counter)/\(currentWorkout.totalCount)次"
        
        changeRepeatCounts(totalCount: currentWorkout.totalCount, timeInterval: currentWorkout.perDuration)
        
        repeatCollectionView.reloadData()
        
    }
    
    private func changeRepeatCounts(totalCount: Int, timeInterval: TimeInterval) {
        
        for i in 1...totalCount {
            let repeatCount = "\(i)/\(totalCount)次"
            repeatCountingText.append(repeatCount)
        }
        
        repeatTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (_) in
            
            if self.counter < totalCount {
                self.repeatLabel.text = self.repeatCountingText[self.counter]
                self.counter += 1
            } else {
                self.repeatTimer?.invalidate()
                self.barTimer?.invalidate()
                self.moveToNextVC()
                
                // Repeat within current workout
                if self.currentRepeat < self.workoutSet[self.workoutIndex].totalRepeat {
                    self.currentRepeat += 1
                    self.changeTitleAndRepeatText()
                    self.updateBarProgress()
                    
                } else {
                    // Finish repo in current workout, ready for next
                    self.workoutIndex += 1
                    self.currentRepeat = 1
                
                }
            }
        })
    }
    
    private func updateBarProgress() {
        
        guard let workoutMinutes = workoutMinutes else { return }
        let maxTime = workoutMinutes * 60.0
        
        currentTIme += 1.0
        barProgressView.progress = self.currentTIme/maxTime
        
        barTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            if self.currentTIme < maxTime {
                self.currentTIme += 1.0
                self.barProgressView.progress = self.currentTIme/maxTime
            } else {
                return
            }
        })
    }
    
    private func moveToNextVC() {
        
        if currentRepeat == workoutSet[workoutIndex].totalRepeat && workoutIndex == (workoutSet.count - 1) {
            performSegue(withIdentifier: "finishWorkout", sender: self)
        } else if currentRepeat == workoutSet[workoutIndex].totalRepeat {
            performSegue(withIdentifier: "startRest", sender: self)
        } else {
            return
        }
        
    }
    
}

extension WorkoutViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return workoutSet[workoutIndex].totalRepeat
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
        
        for _ in 0..<workoutSet[workoutIndex].totalRepeat {
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

extension WorkoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let collectionViewWidth = repeatCollectionView.bounds.width
        let cellSpace = Int(collectionViewWidth) / workoutSet[workoutIndex].totalRepeat
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
