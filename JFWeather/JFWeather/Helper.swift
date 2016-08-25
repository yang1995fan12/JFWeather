//
//  Helper.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/17.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

//ShareSDK
let ShareSDK_AppKey = "1668da0b60824"

//新浪
let Sina_AppKey = "1528259324"
let Sina_AppSecret = "b605c18f3a773347dbfd2bd667d28b32"

let Sina_OAuth_Html = "http://www.baidu.com"

//微信(别人的等自己的好了换掉)
let weixin_AppID = "wx8571a4f11404252a"
let weixin_AppSecret = "129663c38c2a9302ec7ba3b608a245c8"

//QQ
let QQ_AppID = "1105638816"
let QQ_AppKey = "f9xp11737m26OBoj"


//左右界面的背景颜色
let leftControllerAndRightControllerBGColor = UIColor(red:CGFloat(40.0/255.0),green:CGFloat(37.0/255.0),blue:CGFloat(40.0/255.0),alpha:1.0)

//通知名称
let LeftControllerTypeChangedNotification = "LeftControllerTypeChangedNotification"

let AutoLocationNotification = "AutoLocationNotification"

let ChooseLocationCityNotification = "ChooseLocationCityNotification"

let DeleteHistoryCityNotification = "DeleteHistoryCityNotification"

//如何存储历史城市记录
//文件读写
let history_city_path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] + "/" + "history_city_path.txt"

class Helper: NSObject {

    class func readChaceCity()->[String] {
        
        let array = NSArray(contentsOfFile:history_city_path)
        if array == nil {
            return []
        } else {
            if array?.count == 0 {
                return []
            } else {
                var citys = [String]()
                for ele in array! {
                    citys.append(ele as! String)
                }
                return citys
            }
        }
        
    }
    
    class func inseartCity(city:String)->Bool {
        //判断是否存在
        var old_citys = Helper.readChaceCity()
        if old_citys.contains(city) {
            let index = old_citys.indexOf(city)
            old_citys.removeAtIndex(index!)
        }
        //将city插入到数据的最前面
        old_citys.insert(city, atIndex: 0)
        
        let array = NSMutableArray()
        for ele in old_citys {
            array.addObject(ele)
        }
        
        return array.writeToFile(history_city_path, atomically: true)
    }
    
    class func deleteCity(city:String)->Bool {
        //判断是否存在
        var old_citys = Helper.readChaceCity()
        if old_citys.contains(city) {
            let index = old_citys.indexOf(city)
            old_citys.removeAtIndex(index!)
        }

        let array = NSMutableArray()
        for ele in old_citys {
            array.addObject(ele)
        }
        
        return array.writeToFile(history_city_path, atomically: true)
    }
}
