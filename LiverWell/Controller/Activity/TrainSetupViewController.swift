//
//  ActivitySetupViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class TrainSetupViewController: UIViewController, UITableViewDelegate {

    @IBAction func dismissBtnPressed(_ sender: UIBarButtonItem) {

        dismiss(animated: true)

    }
    
    @IBOutlet var timerBtns: [UIButton]!
    
    @IBAction func selectTimerPressed(_ sender: UIButton) {
        
        for btn in timerBtns {
            
            btn.isSelected = false
            
        }
        
        sender.isSelected = true
        
        selectTimer(toTime: sender.tag)
        
    }
    
    private func selectTimer(toTime: Int) {
        
    }

    @IBOutlet weak var navBarItem: UINavigationItem!

    @IBOutlet weak var tableView: UITableView!

    var navTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarItem.title = navTitle

        let cellNib = UINib(nibName: "SetupActivityTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "SetupActivityTableViewCell")

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
