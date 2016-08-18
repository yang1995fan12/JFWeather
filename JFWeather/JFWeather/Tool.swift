//
//  Tool.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/18.
//  Copyright © 2016年 yf. All rights reserved.
//

import Foundation

class Tool {
    class func returnDate(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch")
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.stringFromDate(date)
    }
    
    enum WeekDays:String {
        case Monday = "周一"
        case Tuesday = "周二"
        case Wednesday = "周三"
        case Thursday = "周四"
        case Friday = "周五"
        case Saturday = "周六"
        case Sunday = "周日"
    }
    
    class func returnWeekDay(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch")
        dateFormatter.dateFormat = "EEEE"
        
        let dateStr = dateFormatter.stringFromDate(date)
        switch dateStr {
        case "Monday":
            return WeekDays.Monday.rawValue
        case "Tuesday":
            return WeekDays.Tuesday.rawValue
        case "Wednesday":
            return WeekDays.Wednesday.rawValue
        case "Thursday":
            return WeekDays.Thursday.rawValue
        case "Friday":
            return WeekDays.Friday.rawValue
        case "Saturday":
            return WeekDays.Saturday.rawValue
        default:
            return WeekDays.Sunday.rawValue
        }
    }
}