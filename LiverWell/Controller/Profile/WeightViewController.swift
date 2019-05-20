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
    @IBOutlet weak var starIcon: UIImageView!
    
    let userDefaults = UserDefaults.standard

    let weightProvider = WeightProvider()

    var weightDataArray = [WeightData]() {

        didSet {
            tableView.reloadData()

            setChartValues()

            layoutStatus()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChartView()

        readWeight()

        levelCollectionView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        layoutStatus()
    }

    private func readWeight() {

        weightProvider.getWeight { (result) in

            switch result {

            case .success(let weightDataArray):

                self.weightDataArray = weightDataArray

                print("==============")
                print(weightDataArray)

            case .failure(let error):

                print(error)
            }
        }
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

    private func layoutStatus() {

        weightProvider.getStatus { [weak self] (status) in

            guard let strongSelf = self else { return }

            let weightSinceStart = status.weightSinceStart

            let weightSinceMonth = status.weightSinceMonth

            if weightSinceStart > 0 {
                strongSelf.weightSinceStartLabel.text = "+\(weightSinceStart.format(f: ".1"))"
            } else {
                strongSelf.weightSinceStartLabel.text = weightSinceStart.format(f: ".1")
            }

            let percentage = Int(Float((0 - weightSinceMonth) / 1) * 100)

            if weightSinceMonth > 0 {
                strongSelf.weightSinceMonthLabel.text = "+\(weightSinceMonth.format(f: ".1"))"
                strongSelf.progressView.progress = 0
                strongSelf.progressLabel.text = "0%"
                strongSelf.starIcon.isHidden = true
            } else if percentage >= 100 {
                strongSelf.weightSinceMonthLabel.text = weightSinceMonth.format(f: ".1")
                strongSelf.progressView.progress = Float((0 - weightSinceMonth) / 1)
                strongSelf.progressLabel.text = "\(Int(Float((0 - weightSinceMonth) / 1) * 100))%"
                strongSelf.starIcon.isHidden = false
            } else {
                strongSelf.weightSinceMonthLabel.text = weightSinceMonth.format(f: ".1")
                strongSelf.progressView.progress = Float((0 - weightSinceMonth) / 1)
                strongSelf.progressLabel.text = "\(Int(Float((0 - weightSinceMonth) / 1) * 100))%"
                strongSelf.starIcon.isHidden = true
            }

            strongSelf.startMonthLabel.text = status.signupTime

            strongSelf.currentMonthLabel.text = DateFormatter.chineseYearMonth(date: Date())

            strongSelf.expectedWeightLabel.text = String(status.expectWeight)

            strongSelf.weightSinceMonthLabel.text = String(status.weightSinceMonth)

        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Cloud Firestore
        guard let uid = userDefaults.value(forKey: "uid") as? String else { return }

        let weightRef = AppDelegate.db.collection("users").document(uid).collection("weight")

        let documentID = self.weightDataArray[indexPath.row].documentID

        // Action sheet setup
        let optionMenu = UIAlertController(title: "編輯體重資料", message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "修改體重", style: .default) { [weak self] (_) in

            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let desVC = profileStoryboard.instantiateViewController(withIdentifier: "RecordWeightViewController")
            guard let recordWeightVC = desVC as? RecordWeightViewController else { return }
            recordWeightVC.weightDocumentID = documentID
            recordWeightVC.reloadDataAfterUpdate = { [weak self] in

                guard let strongSelf = self else { return }

                strongSelf.weightDataArray = [WeightData]()

                strongSelf.readWeight()

//                self?.tableView.reloadData()
            }

            self?.present(recordWeightVC, animated: true)
        }

        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { [weak self] (_) in

            // Delete document
            guard let documentID = documentID else { return }

            weightRef.document(documentID).delete(completion: { (error) in
                if let error = error {
                    print("Error deleting document: \(error)")
                } else {
                    print("Document succesfully deleted")
                }
            })

            guard let strongSelf = self else { return }

            strongSelf.weightDataArray = [WeightData]()

            strongSelf.readWeight()

            strongSelf.tableView.reloadData()

            strongSelf.setChartValues()
        }

        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
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
