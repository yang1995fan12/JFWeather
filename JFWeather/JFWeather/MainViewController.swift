//
//  MainViewController.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/10.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var myTableView:UITableView!
    
    let header = MJRefreshNormalHeader()
    
    var cur_weather_info:NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor  = UIColor.blackColor()
        self.layoutNavigationBar(Tool.returnDate(NSDate()), weekDay: Tool.returnWeekDay(NSDate()), cityName: "深圳")
        
        self.requst("深圳")
        
        self.myTableView = UITableView(frame: self.view.bounds,style: .Plain)
        self.view.addSubview(self.myTableView)
        
//        //MJRefresh  下拉刷新
        
        self.myTableView.mj_header = header
        
        header.refreshingBlock = {
            print("下拉刷新")
            self.layoutNavigationBar(Tool.returnDate(NSDate()), weekDay: Tool.returnWeekDay(NSDate()), cityName: "宁都")
            self.requst("宁都")
        }
        
        
        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        
        let nib = UINib(nibName: "MainTableViewCell",bundle: NSBundle.mainBundle())
        self.myTableView.registerNib(nib, forCellReuseIdentifier: "cellReuseIdentifier")
        
        //设置主页面高度
        self.myTableView.rowHeight = 720
        
        //先把表视图隐藏
        self.myTableView.hidden = true
        
        //将表格分割线取消
        self.myTableView.separatorStyle = .None
    }
    
    //MARK:********导航栏**********
    
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
    
    //MARK:*****请求数据*******
    
    //如何从服务器端请求数据
    //xml和json
    func requst(cityName:String) {
        
        let session = NSURLSession.sharedSession()

        //请求7天的天气情况
        //在URL中不能够出现中文等特殊的字符（所以要用stringByAddingPercentEncodingWithAllowedCharacter转换）
        let urlString = "http://api.k780.com:88/?app=weather.future&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        
        let url = NSURL(string: urlString!)
        let task = session.dataTaskWithURL(url!) { (data, response, error) in
            //  data 请求回来的数据
            //  response 里面包含  数据长度  服务器信息等
            //  error nil 表示请求成功  反之请求失败
            if error == nil {
                
                //json解析
                let weatherInfo = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                
                let array = weatherInfo!["result"] as! NSArray
                let dic = array[0] as! NSDictionary
                let dayWeather = WeatherInfo(dic: dic)
                //print(dayWeather.weather)
                //更新UI必须要返回主线程执行
                dispatch_async(dispatch_get_main_queue(),{
                    self.view.backgroundColor = Tool.returnWeatherBGColor(dayWeather.weather!)
                    self.myTableView.backgroundColor = Tool.returnWeatherBGColor(dayWeather.weather!)
                    //导航栏颜色
                    self.navigationController?.navigationBar.backgroundColor = Tool.returnWeatherBGColor(dayWeather.weather!)
                    
                    //拿到首页的cell,改变cell的颜色
                    let indexPath = NSIndexPath(forRow: 0,inSection: 0)
                    let cell = self.myTableView.cellForRowAtIndexPath(indexPath)
                    cell?.backgroundColor = Tool.returnWeatherBGColor(dayWeather.weather!)
                    
                    //表视图呈现
                    self.myTableView.hidden = false
                    
                    //发送通知
                    NSNotificationCenter.defaultCenter().postNotificationName(LeftControllerTypeChangedNotification, object: nil, userInfo: ["data":array])
                    
                    //停止刷新
                    self.header.endRefreshing()
                })
                
                
            }
            
        }
        
        //请求开始
        task.resume()
        
        
        //请求当天的天气信息
        let cur_urlString = "http://api.k780.com:88/?app=weather.today&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let cur_url = NSURL(string: cur_urlString!)
        let cur_task = session.dataTaskWithURL(cur_url!) { (data, response, error) in
            //  data 请求回来的数据
            //  response 里面包含  数据长度  服务器信息等
            //  error nil 表示请求成功  反之请求失败
            if error == nil {
                
                //json解析
                let weatherInfo = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                let dic = weatherInfo!["result"] as! NSDictionary
                self.cur_weather_info = NSDictionary(dictionary: dic)
                
                print("当天的天气信息\(self.cur_weather_info)")

                //更新UI必须要返回主线程执行
                dispatch_async(dispatch_get_main_queue(),{

                    self.myTableView.reloadData()
                })
                
            }
            
        }
        
        //请求开始
        cur_task.resume()
        
    }
    
    //MARK:*****DataSource,Delegate******
    
    //返回行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellReuseIdentifier") as! MainTableViewCell
        
        if self.cur_weather_info != nil {
            //需要构建逻辑代码来显示不同的图片
            
            let weather = self.cur_weather_info!["weather"] as! String
            cell.messageImageView.image = Tool.returnWeatherImage(weather)
            cell.weatherLabel.text = weather
            
            let temp_curr = self.cur_weather_info!["temp_curr"] as! String
            cell.current_temp_label.text = temp_curr
            
            let temp_low = self.cur_weather_info!["temp_low"] as! String
            let temp_high = self.cur_weather_info!["temp_high"] as! String
            cell.range_temp_label.text = temp_low + "~" + temp_high + "°"
            
            cell.windLabel.text = self.cur_weather_info!["wind"] as? String
            
            cell.range_humidity_label.text = self.cur_weather_info!["humidity"] as? String
        }

        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
