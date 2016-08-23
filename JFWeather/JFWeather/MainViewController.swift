//
//  MainViewController.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/10.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

import CoreLocation

let Current_City_Key = "Current_City_Key"

class MainViewController: UIViewController,NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    var myTableView:UITableView!
    
    let header = MJRefreshNormalHeader()
    
    var cur_weather_info:NSDictionary?
    
    //拿到位置的经纬度
    var locationManager:CLLocationManager!
    
    //根据经纬度解析地名
    let geocoder:CLGeocoder = CLGeocoder()
    
    var current_city:String!
    
    //MARK:******定位*******
    func location() {
        //判断定位是否打开
        if CLLocationManager.locationServicesEnabled() == false {
            print("定位未打开")
            
        } else {
            self.locationManager = CLLocationManager()
            
            //iOS8之后的定位需要用户授权
//            let version = Float(NSNumberFormatter().numberFromString(UIDevice.currentDevice().systemVersion)!)
//            if version >= 8.0 {
//                self.locationManager.requestAlwaysAuthorization()
//          }
            
            if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8,minorVersion: 0,patchVersion: 0)) {
                self.locationManager.requestAlwaysAuthorization()
            }
            
            
            //开始做定位
            self.locationManager.startUpdatingLocation()
            
            self.locationManager.delegate = self
        }
    }
    
    //定位失败
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:\(error.debugDescription)")
    }
    
    //定位成功
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //停止定位（定位成功后就停止定位，因为一直开着耗电）
        manager.stopUpdatingLocation()
        
        if locations.count > 0 {
           let locationInfo = locations.last
            
           //地名解析
           geocoder.reverseGeocodeLocation(locationInfo!, completionHandler: { (placeMarks, error) in
            if placeMarks?.count > 0 {
                let placeM = placeMarks![0]
                print(placeM.locality)
                
                //回到主线程更新UI
                dispatch_async(dispatch_get_main_queue(),{
                    self.current_city = placeM.locality!
                    
                    //将定位城市名称去掉“市”
                    if self.current_city.containsString("市"){
                        let range = self.current_city.rangeOfString("市")
                        self.current_city.removeRange(range!)
                        
                        
                        self.hub.labelText = "定位成功,正在读取天气信息..."
                        
                        Helper.inseartCity(self.current_city)
                        
                        //保存城市
                        NSUserDefaults.standardUserDefaults().setObject(self.current_city, forKey: Current_City_Key)
                        //结束存储
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    
                    self.initView()
                    })
            }
           })
            
            
        }
    }
    
    //MARK:*******通知********
    func autoLocationAction(sender:NSNotification) {
        self.location()
    }
    
    func chooseLocationCityAction (sender:NSNotification) {
        self.current_city = sender.userInfo!["choose_city"] as! String
        Helper.inseartCity(self.current_city)
        self.initView()
    }
    
    //MARK:******程序入口********
    
    var hub:MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(autoLocationAction), name: AutoLocationNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(chooseLocationCityAction), name: ChooseLocationCityNotification, object: nil)
        
        self.view.backgroundColor  = UIColor.blackColor()
        
        
        let theCity = NSUserDefaults.standardUserDefaults().valueForKey(Current_City_Key)
        
        self.hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        if theCity == nil {
            //定位之前 动画
            
            self.hub.labelText = "正在定位..."
            self.location()
        } else {
            self.current_city = theCity as! String
            self.initView()
        }
       
    }
    
    func initView() {
        
        self.layoutNavigationBar(Tool.returnDate(NSDate()), weekDay: Tool.returnWeekDay(NSDate()), cityName: self.current_city)
        
        self.requst(self.current_city)
        
        if self.myTableView == nil {
            //回到ScrollView的原点坐标
            self.automaticallyAdjustsScrollViewInsets = false
            
            self.myTableView = UITableView(frame: CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height),style: .Plain)
            self.view.addSubview(self.myTableView)
            
            //MJRefresh  下拉刷新
            
            self.myTableView.mj_header = header
            
            header.refreshingBlock = {
                print("下拉刷新")
                self.layoutNavigationBar(Tool.returnDate(NSDate()), weekDay: Tool.returnWeekDay(NSDate()), cityName: self.current_city)
                self.requst(self.current_city)
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
    
    var rootController:UIViewController?
    func shareAction(sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "分享天气",message: "",preferredStyle: .ActionSheet)
        let sinaAction = UIAlertAction(title: "分享到新浪微博",style: .Default) { (action:UIAlertAction) -> Void in
        }
        actionSheet.addAction(sinaAction)
        
        let QQFriendAction = UIAlertAction(title: "分享到QQ好友",style: .Default) { (action:UIAlertAction) -> Void in
        }
        actionSheet.addAction(QQFriendAction)
        
        let QQZoneAction = UIAlertAction(title: "分享到QQ空间",style: .Default) { (action:UIAlertAction) -> Void in
        }
        actionSheet.addAction(QQZoneAction)
        
        let wechatFriendAction = UIAlertAction(title: "分享到微信好友",style: .Default) { (action:UIAlertAction) -> Void in
        }
        actionSheet.addAction(wechatFriendAction)
        
        let wechatCicleAction = UIAlertAction(title: "分享到朋友圈",style: .Default) { (action:UIAlertAction) -> Void in
        }
        actionSheet.addAction(wechatCicleAction)
        
        let cancleAction = UIAlertAction(title: "取消",style: .Default) { (action:UIAlertAction) -> Void in
        }
        actionSheet.addAction(cancleAction)
        
        
        self.rootController?.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //点击设置事件
    func settingAction(sender:UIBarButtonItem) {
        
    }
    
    //MARK:*****请求数据*******
    
    //如何从服务器端请求数据
    //xml和json
    func requst(cityName:String) {
        
        //请求7天的天气情况
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
                let weatherInfo = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                let array = weatherInfo!["result"] as! NSArray

                //更新UI必须要返回主线程执行
                dispatch_async(dispatch_get_main_queue(),{
                    
                    //发送通知
                    NSNotificationCenter.defaultCenter().postNotificationName(LeftControllerTypeChangedNotification, object: nil, userInfo: ["data":array])
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
                    
                    let cur_wether_msg = self.cur_weather_info!["weather"] as! String
                    
                    self.view.backgroundColor = Tool.returnWeatherBGColor(cur_wether_msg)
                    self.myTableView.backgroundColor = Tool.returnWeatherBGColor(cur_wether_msg)
                    //导航栏颜色
                    self.navigationController?.navigationBar.backgroundColor = Tool.returnWeatherBGColor(cur_wether_msg)
                    
                    //拿到首页的cell,改变cell的颜色
                    let indexPath = NSIndexPath(forRow: 0,inSection: 0)
                    let cell = self.myTableView.cellForRowAtIndexPath(indexPath)
                    cell?.backgroundColor = Tool.returnWeatherBGColor(cur_wether_msg)
                    
                    //表视图呈现
                    self.myTableView.hidden = false

                    //停止刷新
                    self.header.endRefreshing()
                    
                    self.myTableView.reloadData()
                    
                    //隐藏
                    self.hub.hideAnimated(true)
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
            cell.weatherImageView.image = Tool.returnWeatherImage(weather)
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
