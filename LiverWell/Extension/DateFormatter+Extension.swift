//
//  DateFormatter+Extension.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/10.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation

extension DateFormatter {

    // ex: 星期三
    static func chineseWeekday(date: Date) -> String {
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        var day = dayFormatter.string(from: date)
        
        var chineseDay: String {
            switch day {
            case "Monday": return "星期一"
            case "Tuesday": return "星期二"
            case "Wednesday": return "星期三"
            case "Thursday": return "星期四"
            case "Friday": return "星期五"
            case "Saturday": return "星期六"
            default: return "星期日"
            }
        }
        
        return chineseDay
    }
    
    // ex: 5月10日
    static func chineseMonthDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M月d日"
        
        return dateFormatter.string(from: date)
    }
    
    // ex: 2019年3月
    static func chineseYearMonth(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy年MM月"
        
        return dateFormatter.string(from: date)
        
    }
    
    // ex: 2019-05-10
    static func yearMonthDay(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
        
    }
    
}
