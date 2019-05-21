//
//  StatusViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Charts

// swiftlint:disable identifier_name
class StatusViewController: UIViewController, UITableViewDelegate, ChartViewDelegate {
    
    @IBOutlet weak var weekStartEndLabel: UILabel!
    
    @IBOutlet weak var chartView: BarChartView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextWeekBtn: UIButton!
    
    @IBOutlet weak var previousWeekBtn: UIButton!
    
    let statusProvider = StatusProvider()
    
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
        statusProvider.reset()
        weeksBeforeCount += 1
        getWeeklyWorkoutData(weeksBefore: weeksBeforeCount)
        presentWeekLabel(weeksBeforeCount: weeksBeforeCount)
    }
    
    @IBAction func previousWeekBtnPressed(_ sender: UIButton) {
        statusProvider.reset()
        weeksBeforeCount -= 1
        getWeeklyWorkoutData(weeksBefore: weeksBeforeCount)
        presentWeekLabel(weeksBeforeCount: weeksBeforeCount)
    }
    
    func presentWeekLabel(weeksBeforeCount: Int) {
        let today = Date()
        guard let referenceDay = Calendar.current.date(
            byAdding: .day,
            value: 0 + 7 * weeksBeforeCount,
            to: today) else { return }
        let monday = referenceDay.dayOf(.monday)
        let sunday = referenceDay.dayOf(.sunday)
        
        if weeksBeforeCount == 0 {
            weekStartEndLabel.text = "本週記錄"
        } else {
            let mondayOfWeek = DateFormatter.chineseMonthDate(date: monday)
            let sundayOfWeek = DateFormatter.chineseMonthDate(date: sunday)
            weekStartEndLabel.text = "\(mondayOfWeek)至\(sundayOfWeek)"
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getWeeklyWorkoutData(weeksBefore: 0)
        
        weekStartEndLabel.text = "本週記錄"
        
        nextWeekBtn.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        workoutDataArray = [WorkoutData]()
    }
    
    private func getWeeklyWorkoutData(weeksBefore: Int) {
        
        statusProvider.getWeeklyWorkout(weeksBefore: weeksBefore) { (result) in
            
            switch result {
                
            case .success(let result):
                
                self.setupActivityEntry()

                self.setChartData(count: 7, range: 60)

                self.barChartViewSetup()
                
//                print(result)
                
            case .failure(let error):
                
                print(error)
                
            }
        }
        
    }
    
    private func setupActivityEntry() {

        // sort for tableView data display
        let watchTV = ActivityEntry(
            title: TrainItem.watchTV.title,
            time: statusProvider.watchTVSum,
            activityType: ActivityType.train.rawValue)

        let backPain = ActivityEntry(
            title: TrainItem.preventBackPain.title,
            time: statusProvider.backPainSum,
            activityType: ActivityType.train.rawValue)

        let wholeBody = ActivityEntry(
            title: TrainItem.wholeBody.title,
            time: statusProvider.wholeBodySum,
            activityType: ActivityType.train.rawValue)

        let upperBody = ActivityEntry(
            title: TrainItem.watchTV.title,
            time: statusProvider.upperBodySum,
            activityType: ActivityType.train.rawValue)

        let lowerBody = ActivityEntry(
            title: TrainItem.lowerBody.title,
            time: statusProvider.lowerBodySum,
            activityType: ActivityType.train.rawValue)

        let longSit = ActivityEntry(
            title: StretchItem.longSit.title,
            time: statusProvider.longSitSum,
            activityType: ActivityType.stretch.rawValue)

        let longStand = ActivityEntry(
            title: StretchItem.longStand.title,
            time: statusProvider.longStandSum,
            activityType: ActivityType.stretch.rawValue)

        let beforeSleep = ActivityEntry(
            title: StretchItem.beforeSleep.title,
            time: statusProvider.beforeSleepSum,
            activityType: ActivityType.stretch.rawValue)

        let tempEntryArray = [watchTV, backPain, wholeBody, upperBody, lowerBody, longSit, longStand, beforeSleep]

        activityEntryArray = tempEntryArray.filter({$0.time != 0})

        activityEntryArray = activityEntryArray.sorted(by: { $0.time > $1.time })

    }
    
    private func barChartViewSetup() {
        
        chartView.animate(yAxisDuration: 0.5)
        
        // toggle YValue
        for set in chartView.data!.dataSets {
            set.drawValuesEnabled = false
        }
        
        // disable highlight
        chartView.data!.highlightEnabled = false
        
        // Toggle Icon
//        for set in chartView.data!.dataSets {
//            set.drawIconsEnabled = !set.drawIconsEnabled
//        }
        
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

            let dailyTrain = statusProvider.weekSum[i][0]
            let dailyStretch = statusProvider.weekSum[i][1]

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
            
            guard let pieChartCell = cell as? PieChartTableViewCell else { return cell }
            
            pieChartCell.layoutView(trainSum: statusProvider.trainTimeSum, stretchSum: statusProvider.stretchTimeSum)
            
            return pieChartCell
            
        default:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityEntryTableViewCell", for: indexPath)
            
            guard let entryCell = cell as? ActivityEntryTableViewCell else { return cell }
            
            let activityEntry = activityEntryArray[indexPath.row]
             
            entryCell.layoutView(
                title: activityEntry.title,
                time: activityEntry.time,
                percentage: statusProvider.percentageOf(entry: activityEntry.time),
                activityType: activityEntry.activityType)
            
            return entryCell
            
        }
        
    }

}
