//
//  ShareViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/14.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Charts
import MBCircularProgressBar

class ShareViewController: UIViewController, ChartViewDelegate {
    
//    @IBOutlet weak var todayStatusBtn: UIButton!
//
//    @IBOutlet weak var weeklyStatusBtn: UIButton!
//
//    @IBOutlet var statusBtns: [UIButton]!
    
    @IBOutlet weak var todayStatusView: UIView!
    
    @IBOutlet weak var weeklyStatusView: UIView!
    
    // today status
    @IBOutlet weak var weekProgressCollectionView: UICollectionView!
    
    @IBOutlet weak var trainProgressView: MBCircularProgressBarView!
    
    @IBOutlet weak var stretchProgressView: MBCircularProgressBarView!
    
    @IBOutlet weak var chartView: BarChartView!
    
    @IBOutlet weak var stretchTimeLabel: UILabel!
    
    @IBOutlet weak var trainTimeLabel: UILabel!
    
    @IBOutlet weak var todayTotalTimeLabel: UILabel!
    
    @IBOutlet weak var todayDateLabel: UILabel!

    var selectedImageIndex = 0
    
    var dailyValue = [Int]()
    
//    @IBAction func selectStatusBtnPressed(_ sender: UIButton) {
//
//        for btn in statusBtns {
//
//            btn.isSelected = false
//
//        }
//
//        sender.isSelected = true
//
//        selectStatus(withTag: sender.tag)
//
//    }
    
    func selectStatus(withTag tag: Int) {
        
        if tag == 0 {
            todayStatusView.isHidden = false
            weeklyStatusView.isHidden = true
            
            selectedImageIndex = tag
            
        } else {
            todayStatusView.isHidden = true
            weeklyStatusView.isHidden = false
            
            selectedImageIndex = tag
            
        }
        
    }
    
    @IBAction func dismissBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true)
        
    }
    
    @IBAction func shareBtnPressed(_ sender: UIButton) {
        
        let renderer = UIGraphicsImageRenderer(size: todayStatusView.bounds.size)
        
        let renderedTodayStatus = renderer.image { (UIGraphicsRendererContext) in
            todayStatusView.drawHierarchy(in: todayStatusView.bounds, afterScreenUpdates: true)
        }
        
        let renderedWeeklyStatus = renderer.image { (_) in
            weeklyStatusView.drawHierarchy(in: weeklyStatusView.bounds, afterScreenUpdates: true)
        }
        
        // image to share
        let renderedImageArray = [ renderedTodayStatus, renderedWeeklyStatus ]
        
        let image = renderedImageArray[selectedImageIndex]
        
        // set up activity view controller
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [
//        UIActivity.ActivityType.airDrop,
//        UIActivity.ActivityType.postToFacebook
//        ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // Properties of BarChart
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    let week = ["ㄧ", "二", "三", "四", "五", "六", "日"]
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " $"
        formatter.positiveSuffix = " $"
        
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        chartView.delegate = self
        
        axisFormatDelegate = self
        
        barChartUpdate()
        barChartViewSetup()
        
    }
    
    func barChartViewSetup() {
        
        // toggle YValue
        for set in chartView.data!.dataSets {
            set.drawValuesEnabled = !set.drawValuesEnabled
        }
        //        chartView.setNeedsDisplay()
        
        // disable highlight
        chartView.data!.highlightEnabled = false
        
        // Toggle Icon
        for set in chartView.data!.dataSets {
            set.drawIconsEnabled = !set.drawIconsEnabled
        }
        chartView.setNeedsDisplay()
        
        // Remove horizonatal line, right value label, legend below chart
        self.chartView.xAxis.drawGridLinesEnabled = false
        self.chartView.leftAxis.axisLineColor = UIColor.clear
        self.chartView.rightAxis.drawLabelsEnabled = false
        self.chartView.rightAxis.enabled = false
        self.chartView.legend.enabled = false
        
        // Change xAxis label from top to bottom
        chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chartView.minOffset = 0
        
    }
    
    func barChartUpdate () {
        
        // Basic set up of plan chart
        
        let entry1 = BarChartDataEntry(x: 1.0, y: Double(50))
        let entry2 = BarChartDataEntry(x: 2.0, y: Double(20))
        let entry3 = BarChartDataEntry(x: 3.0, y: Double(30))
        let entry4 = BarChartDataEntry(x: 3.0, y: Double(40))
        let entry5 = BarChartDataEntry(x: 3.0, y: Double(30))
        let entry6 = BarChartDataEntry(x: 3.0, y: Double(40))
        let entry7 = BarChartDataEntry(x: 3.0, y: Double(30))
        
        let dataSet = BarChartDataSet(
            values: [entry1, entry2, entry3, entry4, entry5, entry6, entry7],
            label: "Weekly Status")
        let data = BarChartData(dataSets: [dataSet])
        chartView.data = data
        chartView.chartDescription?.text = ""
        
        // Color
        dataSet.colors = ChartColorTemplates.vordiplom()
        
        // Refresh chart with new data
        chartView.notifyDataSetChanged()
        
        setChartData(count: 7, range: 60)
    }
    
    // swiftlint:disable identifier_name
    func setChartData(count: Int, range: UInt32) {
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val1 = Double(arc4random_uniform(mult) + mult / 2)
            let val2 = Double(arc4random_uniform(mult) + mult / 2)
            
            return BarChartDataEntry(x: Double(i), yValues: [val1, val2], icon: #imageLiteral(resourceName: "Icon_Profile_Star"))
        }
        
        let set = BarChartDataSet(values: yVals, label: "Weekly Status")
        set.drawIconsEnabled = false
        set.colors = [
            NSUIColor(cgColor: UIColor.Orange!.cgColor),
            NSUIColor(cgColor: UIColor.G1!.cgColor)
        ]
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.white)
        data.barWidth = 0.4
        
        chartView.fitBars = true
        chartView.data = data
        
        // Add string to xAxis
        let xAxisValue = chartView.xAxis
        xAxisValue.valueFormatter = axisFormatDelegate
    }

}

extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
        ) -> Int {
        
        return 7
        
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            
            let days = ["ㄧ", "二", "三", "四", "五", "六", "日"]
            
            let cell = weekProgressCollectionView.dequeueReusableCell(
                withReuseIdentifier: "WeekProgressCollectionViewCell", for: indexPath)
            
            guard let progressCell = cell as? WeekProgressCollectionViewCell else { return cell }
            
            progressCell.day.text = days[indexPath.item]
        
            progressCell.layoutView(value: self.dailyValue[indexPath.item])
            
            return progressCell
        
    }
    
}

extension ShareViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width: 20, height: 40)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            
            return 21
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
}

extension ShareViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return week[Int(value) % week.count]
    }
    
}
