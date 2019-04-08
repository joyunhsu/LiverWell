//
//  PieChartTableViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/8.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit
import Charts

class PieChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var trainDataEntry = PieChartDataEntry(value: 0)
    
    var stretchDataEntry = PieChartDataEntry(value: 0)

    var numberOfDataEntries = [PieChartDataEntry]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        pieChartView.chartDescription?.text = ""
        
        trainDataEntry.value = 5
        
        stretchDataEntry.value = 10
        
        numberOfDataEntries = [trainDataEntry, stretchDataEntry]
        
        updateChartData()
        
    }
    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(values: numberOfDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.orange, UIColor.G1]
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChartView.data = chartData
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
