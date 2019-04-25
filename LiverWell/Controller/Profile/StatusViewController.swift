//
//  StatusViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Charts
import Firebase

// swiftlint:disable identifier_name

class StatusViewController: UIViewController, UITableViewDelegate, ChartViewDelegate {

    @IBOutlet weak var chartView: BarChartView!

    @IBOutlet weak var tableView: UITableView!
    
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    var workoutDataArray = [WorkoutData]()
    
    var trainTimeSum: Int?
    
    var stretchTimeSum: Int? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var activityEntryArray = [ActivityEntry]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var watchTVSum = 0
    var backPainSum = 0
    var wholeBodySum = 0
    var upperBodySum = 0
    var lowerBodySum = 0
    var longSitSum = 0
    var longStandSum = 0
    var beforeSleepSum = 0
    
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

        setChartData(count: 7, range: 60)
        
        barChartViewSetup()
        
        getWeeklyWorkoutData()
        
        let dateComponents = DateComponents(calendar: Calendar.current, year: 2018, month: 11, day: 30)
        let date = dateComponents.date
        let calendar = Calendar.current
//        print("------------")
//        print(calendar.veryShortMonthSymbols)
        
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: -7, to: today)
        print("------------")
        print(tomorrow)
        let weekBefore = Calendar.current.date(byAdding: .month, value: 1, to: today)
        print("------------")
        print(weekBefore)
        
    }
    
    private func getWeeklyWorkoutData() {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let workoutRef = AppDelegate.db.collection("users").document(user.uid).collection("workout")
        
        let today = Date()
        
        workoutRef
            .whereField("created_time", isLessThan: Date())
            .whereField("created_time", isGreaterThan: Calendar.current.date(byAdding: .day, value: -6, to: today))
            .order(by: "created_time", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
            
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                for document in snapshot!.documents {
                    
//                    print("----------------------------")
//                    print("\(document.documentID) => \(document.data())")
                    
                    guard let createdTime = document.get("created_time") as? Timestamp else { return }
                    
                    let date = createdTime.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "M月d日"
                    let convertedDate = dateFormatter.string(from: date)
                    
                    guard let activityType = document.get("activity_type") as? String else { return }
                    guard let title = document.get("title") as? String else { return }
                    guard let workoutTime = document.get("workout_time") as? Int else { return }
                    
                    self?.workoutDataArray.append(
                        WorkoutData(
                            displayCreatedTime: convertedDate,
                            createdTime: date,
                            workoutTime: workoutTime,
                            title: title,
                            activityType: activityType)
                    )
                    
                }
            }
                
                guard let self = self else { return }
//                print("----------------------------")
//                print(self.workoutDataArray)
                
                self.filterArrayGetSum()
                
                self.setupActivityEntry()
                
        }
        
    }
    
    private func filterByDate() {
        
        
        
    }
    
    private func filterArrayGetSum() {
        
        // train array
        let trainArray = self.workoutDataArray.filter({ $0.activityType == "train"})
        self.trainTimeSum = timeSumOf(array: trainArray)
        
        // stretch array
        let stretchArray = self.workoutDataArray.filter({ $0.activityType == "stretch"})
        self.stretchTimeSum = timeSumOf(array: stretchArray)
        
        // watchTV array
        let watchTVArray = self.workoutDataArray.filter({ $0.title == "看電視一邊做"})
        self.watchTVSum = timeSumOf(array: watchTVArray)
        
        // backPain array
        let backPainArray = self.workoutDataArray.filter({ $0.title == "預防腰痛"})
        self.backPainSum = timeSumOf(array: backPainArray)
        
        // wholeBody array
        let wholeBodyArray = self.workoutDataArray.filter({ $0.title == "全身訓練"})
        self.wholeBodySum = timeSumOf(array: wholeBodyArray)
        
        // upperBody array
        let upperBodyArray = self.workoutDataArray.filter({ $0.title == "上半身訓練"})
        self.upperBodySum = timeSumOf(array: upperBodyArray)
        
        // lowerBody array
        let lowerBodyArray = self.workoutDataArray.filter({ $0.title == "下半身訓練"})
        self.lowerBodySum = timeSumOf(array: lowerBodyArray)
        
        // longSit array
        let longSitArray = self.workoutDataArray.filter({ $0.title == "久坐伸展"})
        self.longSitSum = timeSumOf(array: longSitArray)
        
        // longStand array
        let longStandArray = self.workoutDataArray.filter({ $0.title == "久站伸展"})
        self.longStandSum = timeSumOf(array: longStandArray)
        
        // beforeSleep array
        let beforeSleepArray = self.workoutDataArray.filter({ $0.title == "睡前舒緩"})
        self.beforeSleepSum = timeSumOf(array: beforeSleepArray)
        
    }
    
    private func timeSumOf(array: [WorkoutData]) -> Int {
        
        var timeArray = [Int]()
        
        for i in 0..<array.count {
            
            timeArray.append(array[i].workoutTime)
            
        }
        
        let timeSum = timeArray.reduce(0, +)
        
        return timeSum
        
    }
    
    private func percentageOf(entry sum: Int) -> Int {
        
        guard let stretchTimeSum = stretchTimeSum, let trainTimeSum = trainTimeSum else { return 0 }
        
        let totalSum = stretchTimeSum + trainTimeSum
        
        let percentage = lround(Double(sum * 100 / totalSum))
        
        return percentage
        
    }
    
    private func setupActivityEntry() {
        
        let watchTV = ActivityEntry(title: "看電視一邊做", time: watchTVSum, activityType: "train")
        
        let backPain = ActivityEntry(title: "預防腰痛", time: backPainSum, activityType: "train")
        
        let wholeBody = ActivityEntry(title: "全身訓練", time: wholeBodySum, activityType: "train")
        
        let upperBody = ActivityEntry(title: "上半身訓練", time: upperBodySum, activityType: "train")
        
        let lowerBody = ActivityEntry(title: "下半身訓練", time: lowerBodySum, activityType: "train")
        
        let longSit = ActivityEntry(title: "久坐伸展", time: longSitSum, activityType: "stretch")
        
        let longStand = ActivityEntry(title: "久站伸展", time: longStandSum, activityType: "stretch")
        
        let beforeSleep = ActivityEntry(title: "睡前舒緩", time: beforeSleepSum, activityType: "stretch")
        
        let tempEntryArray = [watchTV, backPain, wholeBody, upperBody, lowerBody, longSit, longStand, beforeSleep]
        
        activityEntryArray = tempEntryArray.filter({$0.time != 0})
        
        activityEntryArray = activityEntryArray.sorted(by: { $0.time > $1.time })
        
    }
    
    private func barChartViewSetup() {
        
        // toggle YValue
        for set in chartView.data!.dataSets {
            set.drawValuesEnabled = !set.drawValuesEnabled
        }
//        chartView.setNeedsDisplay()
        
        // disable highlight
        chartView.data!.highlightEnabled = !chartView.data!.isHighlightEnabled
//        chartView.setNeedsDisplay()
        
        // Animate Y
//        chartView.animate(yAxisDuration: 1.5)
        
        // Toggle Icon
//        for set in chartView.data!.dataSets {
//            set.drawIconsEnabled = !set.drawIconsEnabled
//        }
//        chartView.setNeedsDisplay()
        
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
    
    private func setChartData(count: Int, range: UInt32) {
        
        var referenceTimeInterval: TimeInterval = 0
//        if let minTimeInterval = (weightDataArray.map({ $0.createdTime.millisecondsSince1970})).min() {
//            referenceTimeInterval = TimeInterval(minTimeInterval)
//        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        
        let xValuesNumberFormatter = ChartsDateXAxisFormatter(
            referenceTimeInterval: referenceTimeInterval,
            dateFormatter: formatter)
        
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
//            let timeInterval = weightData.createdTime.timeIntervalSince1970
//            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let dailyTrain = 50.0
            let dailyStretch = 30.0
            
            return BarChartDataEntry(x: Double(i), yValues: [dailyTrain, dailyStretch], icon: #imageLiteral(resourceName: "Icon_Profile_Star"))
        }
        
        chartView.xAxis.valueFormatter = xValuesNumberFormatter
        
        let set = BarChartDataSet(values: yVals, label: "Weekly Status")
        set.drawIconsEnabled = false
        set.colors = [
            NSUIColor(cgColor: UIColor.Orange!.cgColor),
            NSUIColor(cgColor: UIColor.G1!.cgColor)
        ]
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
//        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.white)
        data.barWidth = 0.4
        
        chartView.fitBars = true
        chartView.data = data
        
        // Add string to xAxis
//        let xAxisValue = chartView.xAxis
//        xAxisValue.valueFormatter = axisFormatDelegate
    }
    
    private func barChartUpdate () { // 沒用到
        
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
        
    }

}

extension StatusViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return week[Int(value) % week.count]
    }
}

extension StatusViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return 1
            
        default: return activityEntryArray.count
            
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartTableViewCell", for: indexPath)
            
            guard let pieChartCell = cell as? PieChartTableViewCell,
                let weeklyTrainTimeSum = trainTimeSum,
                let weeklyStretchTimeSum = stretchTimeSum
                else { return cell }
            
            pieChartCell.layoutView(trainSum: weeklyTrainTimeSum, stretchSum: weeklyStretchTimeSum)
            
            return pieChartCell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityEntryTableViewCell", for: indexPath)
            
            guard let entryCell = cell as? ActivityEntryTableViewCell else { return cell }
            
            let activityEntry = activityEntryArray[indexPath.row]
             
            entryCell.layoutView(title: activityEntry.title, time: activityEntry.time, percentage: percentageOf(entry: activityEntry.time), activityType: activityEntry.activityType)
            
            return entryCell
            
        }
        
    }

}
