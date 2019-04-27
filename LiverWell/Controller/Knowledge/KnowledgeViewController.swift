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
        
        if sender.isSelected == true {
            
            for btn in categoryBtns {
                
                btn.isSelected = false
                
            }
            
        } else {
            
            for btn in categoryBtns {
                
                btn.isSelected = false
                
            }
            
            sender.isSelected = true
            
        }
        
        setupCategoryBtnView(
            foodIsSelected: foodBtn.isSelected,
            workoutIsSelected: workoutBtn.isSelected,
            liverIsSelected: liverBtn.isSelected
        )
        
        selectListWithIndex(sender)
        
    }
    
    private func selectListWithIndex(_ sender: UIButton) {
        
        selectedIndex = sender.tag
        
        if foodBtn.isSelected == false && workoutBtn.isSelected == false && liverBtn.isSelected == false {
            selectedIndex = 0
            foodBtn.backgroundColor = .G1
            workoutBtn.backgroundColor = .Orange
            liverBtn.backgroundColor = .Yellow
        }
        
    }
    
    private func setupCategoryBtnView(foodIsSelected: Bool, workoutIsSelected: Bool, liverIsSelected: Bool) {
        
        let foodColor = foodIsSelected ? UIColor.G1 : UIColor.B1
        
        let workoutColor = workoutIsSelected ? UIColor.Orange : UIColor.B1
        
        let liverColor = liverIsSelected ? UIColor.Yellow : UIColor.B1
    
        foodBtn.backgroundColor = foodColor
        
        workoutBtn.backgroundColor = workoutColor
        
        liverBtn.backgroundColor = liverColor
        
    }
    
    var listArray: [[Knowledge]] {
        return [knowledgeList, foodList, workoutList, fattyLiverList]
    }
    
    var list: [Knowledge] {
        return listArray[selectedIndex]
    }
    
    var selectedIndex = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    let knowledgeManager = KnowledgeManager()
    
    var knowledgeList = [Knowledge]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedKnowledge: Knowledge?
    
    var foodList = [Knowledge]()
    
    var workoutList = [Knowledge]()
    
    var fattyLiverList = [Knowledge]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        knowledgeManager.getKnowledge { (knowledgeList, _ ) in
            
            guard let knowledgeList = knowledgeList else { return }
            
            self.knowledgeList = knowledgeList
            
            self.filterList()
            
        }

    }
    
    private func filterList() {
        
        foodList = knowledgeList.filter({ return $0.category == "food" })
        workoutList = knowledgeList.filter({ return $0.category == "workout" })
        fattyLiverList = knowledgeList.filter({ return $0.category == "fattyLiver" })
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 134
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "knowledgeDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let detailVC = segue.destination as? DetailKnowledgeViewController {
            
            detailVC.knowledge = list[(tableView.indexPathForSelectedRow?.row)!]
            
        }
        
    }

}

extension KnowledgeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: KnowledgeTableViewCell.self),
            for: indexPath
        )
        
        guard let knowledgeCell = cell as? KnowledgeTableViewCell else { return cell }
        
        let listSelected = list[indexPath.row]
        
        knowledgeCell.layoutView(category: listSelected.category, title: listSelected.title)
        
        knowledgeCell.selectionStyle = .none
        
//        knowledgeCell.bookMarkBtn.tag = indexPath.row
        
        return knowledgeCell
    }

}
