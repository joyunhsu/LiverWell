//
//  Date+Extension.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/22.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation

extension Date {
    
    // swiftlint:disable identifier_name
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded()) // Date to millisecond
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000)) // millisecond to Date
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(
            from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
            ) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(
            from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
            ) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }

    func dateAt(hours: Int, minutes: Int) -> Date {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
    
}
