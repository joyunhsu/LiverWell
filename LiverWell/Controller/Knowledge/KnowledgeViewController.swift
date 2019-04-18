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
    
    @IBOutlet var categoryBtns: [UIButton]!
    
    @IBAction func categoryBtnPressed(_ sender: UIButton) {
        
        for btn in categoryBtns {
            
            btn.isSelected = false
            
            btn.backgroundColor = .B1
            
        }
        
        sender.isSelected = true
        
        selectCategory(withTag: sender.tag)
        
    }
    
    private func selectCategory(withTag: Int) {
        
    }
    
    let knowledgeManager = KnowledgeManager()
    
    var knowledges: [Knowledge]? {
        
        didSet {
         
            tableView.reloadData()
            
        }
        
    }
    
    var selectedKnowledge: Knowledge?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        knowledgeManager.getKnowledge { (knowledges, error) in
            
            self.knowledges = knowledges
            
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 134
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "knowledgeDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? DetailKnowledgeViewController {
            
            detailVC.knowledge = knowledges?[(tableView.indexPathForSelectedRow?.row)!]
            
        }
        
    }

}

extension KnowledgeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knowledges?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: KnowledgeTableViewCell.self),
            for: indexPath
        )
        
        guard let knowledgeCell = cell as? KnowledgeTableViewCell else { return cell }
        
        guard let knowledge = knowledges?[indexPath.row] else { return cell }
        
        knowledgeCell.layoutView(category: knowledge.category, title: knowledge.title)
        
        knowledgeCell.selectionStyle = .none
        
        return knowledgeCell
    }

}
