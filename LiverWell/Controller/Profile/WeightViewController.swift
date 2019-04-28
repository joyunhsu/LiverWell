//
//  WeightViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Charts
import Firebase

class WeightViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var levelCollectionView: UICollectionView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var weightDataArray = [WeightData]() {
        didSet {
            tableView.reloadData()
            setChartValues()
        }
    }
    
    struct WeightData {
        let createdTimeString: String
        let createdTime: Date
        let documentID: String
        let weight: Double
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        setChartValues()
        setupChartView()
        readWeight()
        
        levelCollectionView.isHidden = true
        
    }
    
    @IBAction func recordWeightPressed(_ sender: UIButton) {
        
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        let desVC = profileStoryboard.instantiateViewController(withIdentifier: "RecordWeightViewController")
        guard let recordWeightVC = desVC as? RecordWeightViewController else { return }
        recordWeightVC.weightDocumentID = nil
        recordWeightVC.reloadDataAfterUpdate = { [weak self] in
            
            self?.weightDataArray = [WeightData]()
            
            self?.readWeight()
            
            self?.tableView.reloadData()
            
        }
        
        present(recordWeightVC, animated: true)
    }
    
    private func readWeight() {
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
        weightRef
            .order(by: "created_time", descending: true) // 由新到舊
            .getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    
                    guard let weight = document.get("weight") as? Double else { return }
                    
                    guard let createdTime = document.get("created_time") as? Timestamp else { return }
                    
                    let date = createdTime.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "M月d日"
                    let convertedDate = dateFormatter.string(from: date)
                    
                    self?.weightDataArray.append(
                        WeightData(
                            createdTimeString: convertedDate,
                            createdTime: date,
                            documentID: document.documentID,
                            weight: weight
                        )
                    )
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Cloud Firestore
        guard let user = Auth.auth().currentUser else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(user.uid).collection("weight")
        
        let documentID = self.weightDataArray[indexPath.row].documentID
        
        // Action sheet setup
        let optionMenu = UIAlertController(title: "編輯體重資料", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "修改體重", style: .default) { [weak self] (action) in
            
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let desVC = profileStoryboard.instantiateViewController(withIdentifier: "RecordWeightViewController")
            guard let recordWeightVC = desVC as? RecordWeightViewController else { return }
            recordWeightVC.weightDocumentID = documentID
            recordWeightVC.reloadDataAfterUpdate = { [weak self] in
                
                self?.weightDataArray = [WeightData]()
                
                self?.readWeight()
                
                self?.tableView.reloadData()
                
            }
            
            self?.present(recordWeightVC, animated: true)
            
        }
        
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { [weak self] (action) in
        
            // Delete document
            weightRef.document(documentID).delete() { (error) in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document succesfully updated")
                    }
                }
            
            self?.weightDataArray = [WeightData]()
            
            self?.readWeight()
            
            self?.tableView.reloadData()
            
            self?.setChartValues()
            
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            optionMenu.dismiss(animated: true, completion: nil)
        }
        
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    private func setChartValues() {
        
        var referenceTimeInterval: TimeInterval = 0
        if let minTimeInterval = (weightDataArray.map({ $0.createdTime.millisecondsSince1970})).min() {
            referenceTimeInterval = TimeInterval(minTimeInterval)
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        let xValuesNumberFormatter = ChartsDateXAxisFormatter(
            referenceTimeInterval: referenceTimeInterval,
            dateFormatter: formatter)
        
        let reverseArray = weightDataArray.reversed() // 時間排序由舊到新
        
        var entries = [ChartDataEntry]()
        for weightData in reverseArray {
            let timeInterval = weightData.createdTime.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yValue = weightData.weight
            let entry = ChartDataEntry(x: xValue, y: yValue)
            entries.append(entry)
        }
        
        lineChartView.xAxis.valueFormatter = xValuesNumberFormatter
        
        let lineDataSet = LineChartDataSet(values: entries, label: "Weight Chart")
        lineDataSet.circleRadius = 2.5
        lineDataSet.circleColors = [UIColor.B1!]
        lineDataSet.circleHoleRadius = 0
        lineDataSet.lineWidth = 2.5
        lineDataSet.colors = [UIColor.Orange!]
        
        let gradient = getGradientFilling()
        lineDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        lineDataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: lineDataSet)
        self.lineChartView.data = data

    }
    
    private func getGradientFilling() -> CGGradient {
        
        let colorTop = UIColor.hexStringToUIColor(hex: "F77A25").cgColor
        let colorBottom = UIColor.hexStringToUIColor(hex: "FCB24C").cgColor
        
        let gradientColors = [colorTop, colorBottom] as CFArray
        
        let colorLocations: [CGFloat] = [0.7, 0.0]
        
        return CGGradient.init(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: gradientColors,
            locations: colorLocations)!
    }
    
    private func setupChartView() {
        
        // Remove horizonatal line, right value label, legend below chart
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.axisLineColor = UIColor.clear
        self.lineChartView.rightAxis.drawLabelsEnabled = false
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.legend.enabled = false
        
        // Change xAxis label from top to bottom
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChartView.minOffset = 0
        
    }

}

extension WeightViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = levelCollectionView.dequeueReusableCell(
            withReuseIdentifier: "LevelCollectinoViewCell",
            for: indexPath)
        
        let levelColors: [UIColor] = [
            .hexStringToUIColor(hex: "A5DB7F"),
            .hexStringToUIColor(hex: "FADA5B"),
            .hexStringToUIColor(hex: "F9BC51"),
            .hexStringToUIColor(hex: "F99243"),
            .hexStringToUIColor(hex: "F96936"),
            .hexStringToUIColor(hex: "F73625")
        ]
        
        cell.backgroundColor = levelColors[indexPath.item]
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
        ) -> CGSize {
        let levelCollectionViewWidth = levelCollectionView.bounds.width
        return CGSize(width: levelCollectionViewWidth / 6, height: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
        ) -> CGFloat {
        return 0
    }
    
}

extension WeightViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return weightDataArray.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightEntryTableViewCell", for: indexPath)
        guard let weightCell = cell as? WeightEntryTableViewCell else { return cell }
        
        let weightData = weightDataArray[indexPath.row]
        
        weightCell.layoutView(date: weightData.createdTimeString, weight: weightData.weight)
        
        return cell
    }

}
