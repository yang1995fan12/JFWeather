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
        
        self.view.backgroundColor  = UIColor.purpleColor()
        
        self.layoutNavigationBar(Tool.returnDate(NSDate()), weekDay: Tool.returnWeekDay(NSDate()), cityName: "深圳")
    }
    
    func layoutNavigationBar(date:String,weekDay:String,cityName:String) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let catogryBarItem = UIBarButtonItem(image: UIImage(named:"category_hover"), style: .Plain, target: self, action: #selector(chooseDateAction))
        catogryBarItem.imageInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        
        let dateBarItem = UIBarButtonItem(title: date + "/" + weekDay, style: .Plain, target: self, action: #selector(chooseDateAction))
        self.navigationItem.leftBarButtonItems = [catogryBarItem,dateBarItem]
        
        
        let shareBarItem = UIBarButtonItem(image: UIImage(named: "share_small_hover"), style: .Plain, target: self, action: #selector(shareAction))
        
        let cityBarItem = UIBarButtonItem(title: cityName, style: .Plain, target: nil, action: nil)
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "settings_hover"), style: .Plain, target: self, action: #selector(settingAction))
        self.navigationItem.rightBarButtonItems = [settingBarItem,cityBarItem,shareBarItem]
    }
    
    //
    func chooseDateAction(sender: UIBarButtonItem) {
        
    }
    
    //
    func shareAction(sender: UIBarButtonItem) {
        
    }
    
    //
    func settingAction(sender:UIBarButtonItem) {
        
    }
    
    //如何从服务器端请求数据
    //xml和json
    func requst() {
        
        let session = NSURLSession.sharedSession()
        
        let cityName = "北京"
        
        let urlString = "http://api.k780.com:88/?app=weather.future&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=xml".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let url = NSURL(string: urlString!)
        
        let task = session.dataTaskWithURL(url!) { (data, response, error) in
            //  data 请求回来的数据
            //  response 里面包含  数据长度  服务器信息等
            //  error nil 表示请求成功  反之请求失败
            
            if error == nil {
                
                //xml 解析器
                let xmlParser = NSXMLParser(data:data!)
                
                xmlParser.delegate = self
                
                //开始解析
                xmlParser.parse()
                
            }
            
        }
        //请求开始
        task.resume()
    
    }
    
    //开始解析，拿到节点信息
    var currentNodeName:String!
    
    func parser(parser:NSXMLParser,didStartElement elementName:String,namespaceURI:String?,qualifiedName qName:String?,attributes attributeDice:[String:String]) {
        currentNodeName = elementName
    }
    //解析完成拿到节点中的值
    func parser(parser:NSXMLParser,foundCharacters string:String) {
    //string 表示节点中的值
    let newStr = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if newStr != "" {
            print("\(currentNodeName)------>\(newStr)")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
