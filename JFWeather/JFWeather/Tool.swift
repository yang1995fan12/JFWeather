//
//  Tool.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/18.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class Tool {
    //日期
    class func returnDate(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch")
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.stringFromDate(date)
    }
    //枚举 星期
    enum WeekDays:String {
        case Monday = "周一"
        case Tuesday = "周二"
        case Wednesday = "周三"
        case Thursday = "周四"
        case Friday = "周五"
        case Saturday = "周六"
        case Sunday = "周日"
    }
    //返回星期和日期
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
    //将16进制的字符串转换成一个RGB颜色的格式
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    //返回天气的背景颜色
    class func returnWeatherBGColor(weatherType:String)->UIColor {
        let weatherTypePath = NSBundle.mainBundle().pathForResource("weatherBG", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if element as! String == weatherType || weatherType.hasPrefix(element as! String) {
                    let key = element as! String
                    let value = json![key] as! String
                    return Tool.colorWithHexString(value)
                }
            }
        }
        
        return UIColor.grayColor()
        
    }
    
    //返回天气的类型
    class func returnWeatherType(weatherType:String)->String {
        let weatherTypePath = NSBundle.mainBundle().pathForResource("weatherBG", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if weatherType.hasPrefix(element as! String) {

                    return element as! String
                }
            }
        }
        
        return weatherType
        
    }
    
    
    //返回天气的类型的图片
    class func returnWeatherImage(weatherType:String)->UIImage? {
        let weatherTypePath = NSBundle.mainBundle().pathForResource("weatherImage", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if  weatherType.hasPrefix(element as! String) {
                    
                    let value = json![element as! String] as! String
                    return UIImage(named: value)
                    
                }
            }
        }
        
        return nil
        
    }
    
    //将年月日的时间类型转换成月日的时间类型
    class func retrunNeedDay(getDateString:String)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.dateFromString(getDateString)
        let newFormatter = NSDateFormatter()
        newFormatter.locale = NSLocale(localeIdentifier: "ch")
        newFormatter.dateFormat = "MM/dd"
        let dateStr = newFormatter.stringFromDate(date!)
        return dateStr
    }
    
    
    //如果传入的是星期几就返回周几
    class func returnWeekDay(getWeekDayString:String)->String {
        if getWeekDayString == "星期一" {
            return "周一"
        }else if getWeekDayString == "星期二" {
            return "周二"
        }else if getWeekDayString == "星期三" {
            return "周三"
        }else if getWeekDayString == "星期四" {
            return "周四"
        }else if getWeekDayString == "星期五" {
            return "周五"
        }else if getWeekDayString == "星期六" {
            return "周六"
        }else {
            return "周日"
        }
    }

    
}