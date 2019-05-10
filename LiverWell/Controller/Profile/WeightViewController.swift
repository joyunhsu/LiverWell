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
    
    @IBOutlet weak var startMonthLabel: UILabel!
    
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    @IBOutlet weak var expectedWeightLabel: UILabel!
    
    @IBOutlet weak var weightSinceStartLabel: UILabel!
    
    @IBOutlet weak var weightSinceMonthLabel: UILabel!
    
    @IBOutlet weak var weightLossMonthLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var statusTitleLabel: UILabel!
    
    @IBOutlet weak var statusTitleView: UIView!
    
    @IBOutlet weak var statusCaptionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var levelCollectionView: UICollectionView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    let userDefaults = UserDefaults.standard
    
    var weightDataArray = [WeightData]() {
        didSet {
            tableView.reloadData()
            setChartValues()
        }
    }
    
    var initialWeight: Double = 0
    var lastMonthWeight: Double = 0
    var currentWeight: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()

//        setChartValues()
        setupChartView()
        readWeight()
//        readStatus()
        
        levelCollectionView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readStatus()
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
    
    private func readStatus() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月"
        
        let userDocRef = AppDelegate.db.collection("users").document(uid)
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        let startOfMonth = Date().startOfMonth()
        
        var weightChangeSinceStart: Double = 0
        
        userDocRef
            .getDocument { (document, error) in
            if let document = document, document.exists {
                guard let initial = document.get("initial_weight") as? Double else { return }
                guard let expected = document.get("expected_weight") as? Double else { return }
                guard let signupTime = document.get("signup_time") as? Timestamp else { return }
                
                let date = signupTime.dateValue()
                let convertedDate = dateFormatter.string(from: date)
                self.startMonthLabel.text = convertedDate
                self.expectedWeightLabel.text = String(expected)
                self.initialWeight = initial
            } else {
                print("Document does not exist: \(String(describing: error))")
            }
        }
        
        weightRef
            .whereField("created_time", isLessThan: startOfMonth)
            .order(by: "created_time", descending: true)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                for document in snapshot!.documents {
                    
                    guard let weight = document.get("weight") as? Double else { return }
                    
                    self.lastMonthWeight = weight

                }
            }
        }
        
        weightRef
            .whereField("created_time", isGreaterThan: startOfMonth)
            .order(by: "created_time", descending: true)
            .limit(to: 1)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error getting document: \(error)")
                } else {
                    for document in snapshot!.documents {
                        
                        guard let createdTime = document.get("created_time") as? Timestamp else { return }
                        guard let weight = document.get("weight") as? Double else { return }
                        
                        let date = createdTime.dateValue()
                        let convertedDate = dateFormatter.string(from: date)
                        self?.currentMonthLabel.text = convertedDate
                        self?.currentWeight = weight
                
                        let weightSinceStart = weight - self!.initialWeight
                        
                        if weightSinceStart > 0 {
                            self?.weightSinceStartLabel.text = "+\(weightSinceStart.format(f: ".1"))"
                        } else {
                            self?.weightSinceStartLabel.text = weightSinceStart.format(f: ".1")
                        }
                        
                        let weightSinceMonth = weight - self!.lastMonthWeight
                        if weightSinceMonth > 0 {
                            self?.weightSinceMonthLabel.text = "+\(weightSinceMonth.format(f: ".1"))"
                            self?.progressView.progress = 0
                            self?.progressLabel.text = "0%"
                        } else {
                            self?.weightSinceMonthLabel.text = weightSinceMonth.format(f: ".1")
                            self?.progressView.progress = Float((0 - weightSinceMonth) / 1)
                            self?.progressLabel.text = "\(Int(Float((0 - weightSinceMonth) / 1) * 100))%"
                        }
                        
                    }
                }
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                let weightSinceStart = self.currentWeight - self.initialWeight
                
                if weightSinceStart > 0 {
                    self.weightSinceStartLabel.text = "+\(weightSinceStart.format(f: ".1"))"
                } else {
                    self.weightSinceStartLabel.text = weightSinceStart.format(f: ".1")
                }
                
                let weightSinceMonth = self.currentWeight - self.lastMonthWeight
                if weightSinceMonth > 0 {
                    self.weightSinceMonthLabel.text = "+\(weightSinceMonth.format(f: ".1"))"
                    self.progressView.progress = 0
                } else {
                    self.weightSinceMonthLabel.text = weightSinceMonth.format(f: ".1")
                    self.progressView.progress = Float((0 - weightSinceMonth) / 1)
                }
            }
        }

    }
    
    private func readWeight() {
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
        weightRef
            .order(by: "created_time", descending: true) // 由新到舊
            .getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    
                    guard let createdTime = document.get("created_time") as? Timestamp else { return }
                    
                    var json = document.data()
                    
                    json["created_time"] = nil
                    
                    var item = try? document.decode(as: WeightData.self, data: json)
                    
                    item?.createdTime = createdTime.dateValue()
                    
                    item?.documentID = document.documentID
                    
                    self?.weightDataArray.append(item!)
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Cloud Firestore
        
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }
        
        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")
        
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
            guard let documentID = documentID else { return }
            
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
        if let minTimeInterval = (weightDataArray.map({ $0.createdTime!.millisecondsSince1970})).min() {
            referenceTimeInterval = TimeInterval(minTimeInterval)
        }
        
        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
        formatter.dateFormat = "M月d日"
        formatter.locale = Locale.current
        
        let xValuesNumberFormatter = ChartsDateXAxisFormatter(
            referenceTimeInterval: referenceTimeInterval,
            dateFormatter: formatter)
        
        let reverseArray = weightDataArray.reversed() // 時間排序由舊到新
        
        var entries = [ChartDataEntry]()
        for weightData in reverseArray {
            let timeInterval = weightData.createdTime!.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let yValue = weightData.weight
            let entry = ChartDataEntry(x: xValue, y: yValue)
            entries.append(entry)
        }
        
        lineChartView.xAxis.valueFormatter = xValuesNumberFormatter
        
        let lineDataSet = LineChartDataSet(entries: entries, label: "Weight Chart")
        lineDataSet.circleRadius = 2.5
        lineDataSet.circleColors = [UIColor.B1!]
        lineDataSet.circleHoleRadius = 0
        lineDataSet.lineWidth = 2
        lineDataSet.colors = [UIColor.Orange!]
        lineDataSet.drawValuesEnabled = false // hide y-values
        
        let gradient = getGradientFilling()
        lineDataSet.fillAlpha = 0.7
        lineDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        lineDataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: lineDataSet)
        self.lineChartView.data = data

    }
    
    private func getGradientFilling() -> CGGradient {
        
        let colorTop = UIColor.Yellow!.cgColor
        let colorBottom = UIColor.Orange!.cgColor
//        let colorTop = UIColor.hexStringToUIColor(hex: "F77A25").cgColor
//        let colorBottom = UIColor.hexStringToUIColor(hex: "FCB24C").cgColor
        
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
        self.lineChartView.xAxis.axisLineColor = .clear
        
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
