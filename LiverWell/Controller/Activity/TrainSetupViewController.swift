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
    
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var navTitle: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navBarItem.title = navTitle
        
        let cellNib = UINib(nibName: "SetupActivityTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "SetupActivityTableViewCell")

    }


}

extension TrainSetupViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupActivityTableViewCell", for: indexPath) as! SetupActivityTableViewCell
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 130
//    }
    
    
}
