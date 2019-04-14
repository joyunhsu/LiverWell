//
//  PauseViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/11.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var workoutImageView: UIImageView!
    
    @IBOutlet weak var barProgressView: UIProgressView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentTime: Float = 0.0
    
    var maxTime: Float = 0.0
    
    @IBAction func resumeWorkoutPressed(_ sender: UIButton) {
        
        dismiss(animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barProgressView.progress = currentTime / maxTime
        
        let firstCell = UINib(
            nibName: String(describing: FirstActivityInfoTableViewCell.self),
            bundle: nil
        )
        
        tableView.register(
            firstCell,
            forCellReuseIdentifier: String(describing: FirstActivityInfoTableViewCell.self)
        )
        
        let secondCell = UINib(
            nibName: String(describing: SecondActivityInfoTableViewCell.self),
            bundle: nil
        )
        
        tableView.register(
            secondCell,
            forCellReuseIdentifier: String(describing: SecondActivityInfoTableViewCell.self)
        )

    }

}

extension PauseViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: FirstActivityInfoTableViewCell.self),
            for: indexPath
        )
        
        let cellReuse = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SecondActivityInfoTableViewCell.self),
            for: indexPath
        )
        
        guard let firstCell = cell as? FirstActivityInfoTableViewCell else { return cell }
        
        guard let secondCell = cellReuse as? SecondActivityInfoTableViewCell else { return cell }
        
        switch indexPath.row {
        
        case 0: return firstCell
            
        default: return secondCell
            
        }
    }

}
