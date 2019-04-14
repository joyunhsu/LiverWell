//
//  KnowledgeViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/6.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class KnowledgeViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var foodBtn: UIButton!

    @IBOutlet weak var workoutBtn: UIButton!

    @IBOutlet weak var liverBtn: UIButton!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 134
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "knowledgeDetail", sender: self)
        
    }

}

extension KnowledgeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: KnowledgeTableViewCell.self),
            for: indexPath
        )
        
        guard let knowledgeCell = cell as? KnowledgeTableViewCell else { return cell }
        
        knowledgeCell.selectionStyle = .none
        
        return knowledgeCell
    }

}
