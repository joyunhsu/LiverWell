//
//  StretchSetupViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Firebase

class StretchSetupViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {

        dismiss(animated: true)

    }

    @IBOutlet weak var navBarItem: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!
    
    let workoutElementManager = WorkoutElementManager()
    
    var workoutElement: WorkoutElement? {
        didSet {
            tableView.reloadData()
            
            setupView()
        }
    }
    
    var idUrl: String?
    
    var recordStretchTime: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "SetupActivityTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "SetupActivityTableViewCell")
        
        guard let idUrl = idUrl else { return }
        
        workoutElementManager.getWorkoutElement(id: idUrl) { (workoutElement, error) in
            self.workoutElement = workoutElement
        }

    }
    
    private func setupView() {
        
        guard let workoutElement = workoutElement else { return }
        
        navBarItem.title = workoutElement.title
        
        iconImageView.image = UIImage(named: workoutElement.icon)
        
        descriptionLabel.text = workoutElement.description
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? StretchNavViewController {
//            desVC.workoutMinutes = workoutMinutes
            desVC.workoutArray = workoutElement?.workoutSet
        }
        
        if let practiceVC = segue.destination as? PracticeViewController {
            practiceVC.workoutArray = workoutElement?.workoutSet
        }
    }
    
    @IBAction func unwindtoSetup(segue: UIStoryboardSegue) {
        
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        guard let user = Auth.auth().currentUser else { return }
        
        guard let workoutElement = workoutElement else { return }
        
        guard let recordStretchTime = recordStretchTime else { return }
        
        if recordStretchTime > 0 {
            AppDelegate.db.collection("users").document(user.uid).collection("workout").addDocument(
                data: [
                    "activity_type": "stretch",
                    "title": workoutElement.title,
                    "workout_time": recordStretchTime,
                    "created_time": time
            ]) { (error) in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Stretch Workout Time Document succesfully updated")
                }
            }
        }
        
    }
}

extension StretchSetupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupActivityTableViewCell", for: indexPath)
        
        guard let setupCell = cell as? SetupActivityTableViewCell else { return cell }
        
        guard let workoutSet = workoutElement?.workoutSet[indexPath.row] else { return cell }
        
        setupCell.layoutView(image: workoutSet.thumbnail, title: workoutSet.title)

        return setupCell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

}
