//
//  ActivitySetupViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class TrainSetupViewController: UIViewController, UITableViewDelegate {
    
    var selectedTime: Float? {
        didSet {
            startBtn.isEnabled = true
            startBtn.backgroundColor = .Orange
        }
    }

    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {

        dismiss(animated: true)

    }
    
    @IBOutlet var timerBtns: [UIButton]!
    
    @IBOutlet weak var startBtn: UIButton!
    
    @IBAction func selectTimerPressed(_ sender: UIButton) {
        
        for btn in timerBtns {
            
            btn.isSelected = false
            
        }
        
        sender.isSelected = true
        
        selectTimer(withTag: sender.tag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? NavigationViewController,
            let workoutMinutes = selectedTime {
            desVC.workoutMinutes = workoutMinutes
        }
    }
    
    private func selectTimer(withTag tag: Int) {
        
        if tag == 0 {
            selectedTime = 5.0
        } else if tag == 1 {
            selectedTime = 10.0
        } else if tag == 2 {
            selectedTime = 15.0
        }
        
    }

    @IBOutlet weak var navBarItem: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!

    var navTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarItem.title = navTitle

        let cellNib = UINib(nibName: "SetupActivityTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "SetupActivityTableViewCell")
        
        startBtn.isEnabled = false

    }
    
    @IBAction func unwindtoSetup(segue: UIStoryboardSegue) {
        
    }

}

extension TrainSetupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupActivityTableViewCell", for: indexPath)
        
        guard let setupCell = cell as? SetupActivityTableViewCell else { return cell }

        return setupCell

    }

}
