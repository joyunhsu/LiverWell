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

// swiftlint:disable identifier_name
class WeightViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var levelCollectionView: UICollectionView!
    
    @IBOutlet weak var lineChartView: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setChartValues()
        setupChartView()
        readWeight()
        
    }
    
    private func readWeight() {
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        
        AppDelegate.db.collection("users").document(uid).collection("weight").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    guard let weight = document.get("weight") as? Double else { return }
                    print("----------")
                    print(weight)
                    
                    if let createdTime = document.get("created_time") as? Timestamp {
                        let date = createdTime.dateValue()
                        print("-----------")
                        print(date)
                    }
                    
                }
            }
        }
        
    }
    
    private func setChartValues(_ count: Int = 20) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            
            let val = Double(arc4random_uniform(UInt32(count)) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let lineDataSet = LineChartDataSet(values: values, label: "Weight Chart")
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
        return 1
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightEntryTableViewCell", for: indexPath)
        
        return cell
    }

}
