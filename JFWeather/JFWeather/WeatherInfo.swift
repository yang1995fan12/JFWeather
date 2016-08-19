//
//  WeatherInfo.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/19.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class WeatherInfo: NSObject {
    /*
     {
     cityid = 101280601;
     citynm = "\U6df1\U5733";
     cityno = shenzhen;
     days = "2016-05-23";
     "humi_high" = 0;
     "humi_low" = 0;
     humidity = "0\U2109/0\U2109";
     "temp_high" = 30;
     "temp_low" = 25;
     temperature = "30\U2103/25\U2103";
     weaid = 169;
     weather = "\U591a\U4e91";
     "weather_icon" = "http://api.k780.com:88/upload/weather/d/1.gif";
     "weather_icon1" = "http://api.k780.com:88/upload/weather/n/1.gif";
     weatid = 2;
     weatid1 = 2;
     week = "\U661f\U671f\U4e00";
     wind = "\U65e0\U6301\U7eed\U98ce\U5411";
     windid = 124;
     winp = "\U5fae\U98ce";
     winpid = 125;
     },
     */
    var weaid:String?
    var days:String?
    var week:String?
    var cityno:String?
    var citynm:String?
    var cityid:String?
    var temperature:String?
    var humidity:String?
    var weather:String?
    var weather_icon:String?
    var weather_icon1:String?
    var wind:String?
    var winp:String?
    var temp_high:String?
    var temp_low:String?
    var humi_high:String?
    var humi_low:String?
    var weatid:String?
    var weatid1:String?
    var windid:String?
    var winpid:String?
    
    init(dic:NSDictionary) {
        super.init()
        self.setValuesForKeysWithDictionary(dic as! [String : AnyObject])
    }
}
