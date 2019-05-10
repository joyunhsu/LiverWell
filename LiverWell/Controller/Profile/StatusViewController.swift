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
    
    @IBOutlet weak var weekStartEndLabel: UILabel!
    
    @IBOutlet weak var chartView: BarChartView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextWeekBtn: UIButton!
    
    @IBOutlet weak var previousWeekBtn: UIButton!
    
    var weeksBeforeCount = 0 {
        didSet {
            if weeksBeforeCount == 0 {
                nextWeekBtn.isHidden = true
            } else {
                nextWeekBtn.isHidden = false
            }
        }
    }
    
    @IBAction func nextWeekBtnPressed(_ sender: UIButton) {
        print("---yo-----")
        print(Date().timeIntervalSince1970)
        workoutDataArray = [WorkoutData]()
        weeksBeforeCount += 1
        getWeeklyWorkoutData(weeksBefore: weeksBeforeCount)
        presentWeekLabel(weeksBeforeCount: weeksBeforeCount)
        print("-----發大財-----")
        print(Date().timeIntervalSince1970)
    }
    
    @IBAction func previousWeekBtnPressed(_ sender: UIButton) {
        workoutDataArray = [WorkoutData]()
        weeksBeforeCount -= 1
        getWeeklyWorkoutData(weeksBefore: weeksBeforeCount)
        presentWeekLabel(weeksBeforeCount: weeksBeforeCount)
    }
    
    func presentWeekLabel(weeksBeforeCount: Int) {
        let today = Date()
        guard let referenceDay = Calendar.current.date(byAdding: .day, value: 0 + 7 * weeksBeforeCount, to: today) else { return }
        guard let monday = referenceDay.startOfWeek else { return }
        guard let sunday = referenceDay.endOfWeek else { return }
        
        if weeksBeforeCount == 0 {
            weekStartEndLabel.text = "本週記錄"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M月d日"
            weekStartEndLabel.text = "\(dateFormatter.string(from: monday))至\(dateFormatter.string(from: sunday))"
        }
        
    }
    
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
    
    var monSum = [0, 0] // [train, stretch]
    var tueSum = [0, 0]
    var wedSum = [0, 0]
    var thuSum = [0, 0]
    var friSum = [0, 0]
    var satSum = [0, 0]
    var sunSum = [0, 0]
    var weekSum: [[Int]] {
        return [monSum, tueSum, wedSum, thuSum, friSum, satSum, sunSum]
    }
    
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
        
        nextWeekBtn.isHidden = true
        
        weekStartEndLabel.text = "本週記錄"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWeeklyWorkoutData(weeksBefore: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        workoutDataArray = [WorkoutData]()
    }
    
    private func getWeeklyWorkoutData(weeksBefore: Int) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let workoutRef = AppDelegate.db.collection("users").document(user.uid).collection("workout")
        
        let today = Date()
        
        guard let referenceDay = Calendar.current.date(byAdding: .day, value: 0 + 7 * weeksBefore, to: today) else { return }
        
        guard let monday = referenceDay.startOfWeek else { return }
        
        guard let sunday = referenceDay.endOfWeek else { return }
        
        workoutRef
            .whereField("created_time", isLessThan: Calendar.current.date(byAdding: .day, value: 1, to: sunday))
            .whereField("created_time", isGreaterThan: monday)
            .order(by: "created_time", descending: false) // 由舊到新
            .getDocuments { [weak self] (snapshot, error) in
            
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                for document in snapshot!.documents {
                    
                    guard let createdTime = document.get("created_time") as? Timestamp else { return }

                    var json = document.data()
                    
                    json["created_time"] = nil
                    
                    var item = try? document.decode(as: WorkoutData.self, data: json)

                    item?.timestampToDate = createdTime.dateValue()

                    self?.workoutDataArray.append(item!)
                    
                }
            }
                
                self?.sortByTitle()
                
                self?.sortByType()
                
                self?.sortByDayAndType(weeksBefore: weeksBefore)
                
                self?.setupActivityEntry()
                
                self?.setChartData(count: 7, range: 60)
                
                self?.barChartViewSetup()
                
                self?.chartView.animate(yAxisDuration: 1)
                
        }
        
    }
    
    private func sortByDayAndType(weeksBefore: Int) {
        
        let today = Date()
        
        guard let referenceDay = Calendar.current.date(
            byAdding: .day,
            value: 0 + 7 * weeksBefore,
            to: today) else { return }
        
        self.monSum = filterByDayAndType(day: referenceDay.dayOf(.monday))
        
        self.tueSum = filterByDayAndType(day: referenceDay.dayOf(.tuesday))
        
        self.wedSum = filterByDayAndType(day: referenceDay.dayOf(.wednesday))
        
        self.thuSum = filterByDayAndType(day: referenceDay.dayOf(.thursday))
        
        self.friSum = filterByDayAndType(day: referenceDay.dayOf(.friday))
        
        self.satSum = filterByDayAndType(day: referenceDay.dayOf(.saturday))
        
        self.sunSum = filterByDayAndType(day: referenceDay.dayOf(.sunday))
        
    }
    
    private func filterByDayAndType(day: Date) -> [Int] {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dayTrain = workoutDataArray.filter({
            $0.convertedDate == dateFormatter.string(from: day) && $0.activityType == "train"
        })
        
        let dayStretch = workoutDataArray.filter({
            $0.convertedDate == dateFormatter.string(from: day) && $0.activityType == "stretch"
        })
        
        return [timeSumOf(array: dayTrain), timeSumOf(array: dayStretch)]
        
    }
    
    private func sortByTitle() {
        
        self.watchTVSum = getWorkoutSumBy(title: "看電視一邊做")
        
        self.backPainSum = getWorkoutSumBy(title: "預防腰痛")
        
        self.wholeBodySum = getWorkoutSumBy(title: "全身訓練")
        
        self.upperBodySum = getWorkoutSumBy(title: "上半身訓練")
        
        self.lowerBodySum = getWorkoutSumBy(title: "下半身訓練")
        
        self.longSitSum = getWorkoutSumBy(title: "久坐伸展")
        
        self.longStandSum = getWorkoutSumBy(title: "久站伸展")
        
        self.beforeSleepSum = getWorkoutSumBy(title: "睡前舒緩")
        
    }
    
    private func sortByType() {
        
        self.trainTimeSum = getWorkoutSumBy(type: "train")
        
        self.stretchTimeSum = getWorkoutSumBy(type: "stretch")
        
    }
    
    private func getWorkoutSumBy(title: String) -> Int {
        
        let array = self.workoutDataArray.filter({
            $0.title == title
        })
        
        return timeSumOf(array: array)
    }
    
    private func getWorkoutSumBy(type: String) -> Int {
        
        let array = self.workoutDataArray.filter({
            $0.activityType == type
        })
        
        return timeSumOf(array: array)
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
        
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in

            let dailyTrain = weekSum[i][0]
            let dailyStretch = weekSum[i][1]

            return BarChartDataEntry(x: Double(i), yValues: [Double(dailyTrain), Double(dailyStretch)], icon: #imageLiteral(resourceName: "Icon_Profile_Star"))
        }
        
        let set = BarChartDataSet(entries: yVals, label: "Weekly Status")
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
            entries: [entry1, entry2, entry3, entry4, entry5, entry6, entry7],
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
             
            entryCell.layoutView(
                title: activityEntry.title,
                time: activityEntry.time,
                percentage: percentageOf(entry: activityEntry.time),
                activityType: activityEntry.activityType)
            
            return entryCell
            
        }
        
    }

}
