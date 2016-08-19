//
//  MainViewController.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/10.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,NSXMLParserDelegate {
    
    var imgView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor  = UIColor.blackColor()
        self.layoutNavigationBar(Tool.returnDate(NSDate()), weekDay: Tool.returnWeekDay(NSDate()), cityName: "深圳")
        
        self.requst("深圳")
    }
    
    func layoutNavigationBar(date:String,weekDay:String,cityName:String) {
        //设置navigationBar的颜色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //设置leftBarButtonItem
        let catogryBarItem = UIBarButtonItem(image: UIImage(named:"category_hover"), style: .Plain, target: self, action: #selector(chooseDateAction))
        catogryBarItem.imageInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        
        let dateBarItem = UIBarButtonItem(title: date + "/" + weekDay, style: .Plain, target: self, action: #selector(chooseDateAction))
        self.navigationItem.leftBarButtonItems = [catogryBarItem,dateBarItem]
        
        //设置rightBarButtonItem
        let shareBarItem = UIBarButtonItem(image: UIImage(named: "share_small_hover"), style: .Plain, target: self, action: #selector(shareAction))
        
        let cityBarItem = UIBarButtonItem(title: cityName, style: .Plain, target: nil, action: nil)
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "settings_hover"), style: .Plain, target: self, action: #selector(settingAction))
        self.navigationItem.rightBarButtonItems = [settingBarItem,cityBarItem,shareBarItem]
    }
    
    //点击日历事件
    func chooseDateAction(sender: UIBarButtonItem) {
        
    }
    
    //点击分享事件
    func shareAction(sender: UIBarButtonItem) {
        
    }
    
    //点击设置事件
    func settingAction(sender:UIBarButtonItem) {
        
    }
    
    //如何从服务器端请求数据
    //xml和json
    func requst(cityName:String) {
        
        let session = NSURLSession.sharedSession()

        
        //在URL中不能够出现中文等特殊的字符（所以要用stringByAddingPercentEncodingWithAllowedCharacter转换）
        let urlString = "http://api.k780.com:88/?app=weather.future&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        
        let url = NSURL(string: urlString!)
        let task = session.dataTaskWithURL(url!) { (data, response, error) in
            //  data 请求回来的数据
            //  response 里面包含  数据长度  服务器信息等
            //  error nil 表示请求成功  反之请求失败
            if error == nil {
                
                //json解析
                let weatherInfo = try?NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                
                let array = weatherInfo!["result"] as! NSArray
                let dic = array[0] as! NSDictionary
                let dayWeather = WeatherInfo(dic: dic)
                print(dayWeather.weather)
                //更新UI必须要返回主线程执行
                dispatch_async(dispatch_get_main_queue(),{
                    self.view.backgroundColor = Tool.returnWeatherBGColor(dayWeather.weather!)
                    NSNotificationCenter.defaultCenter().postNotificationName(LeftControllerTypeChangedNotification, object: nil, userInfo: ["data":array])
                })
                
                
            }
            
        }
        //请求开始
        task.resume()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
