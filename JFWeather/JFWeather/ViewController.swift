//
//  ViewController.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/10.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /*
     将建好的三个视图控制器的view贴到viewCntroller中
     */

    var mainViewController:UIViewController?
    var leftController:LeftTableViewController?
    var rightController:RightTableViewController?
    
    //滑动速率
    var speed_f:CGFloat?
    
    //条件：什么时候显示中间的View 什么时候显示左边的View 什么时候显示右边的View
    var condition_f:CGFloat?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.speed_f = 0.5
        
        self.condition_f = 0
        
        //将主，左，右三个视图添加到窗口上
        let rootController = MainViewController()
        self.mainViewController = UINavigationController(rootViewController:rootController)
        
        
        self.leftController = LeftTableViewController()
        self.view.addSubview((self.leftController?.view)!)
        
        self.rightController = RightTableViewController()
        self.view.addSubview((self.rightController?.view)!)
        self.rightController?.controller = self
        
        self.view.addSubview((self.mainViewController?.view)!)
        
        //将左右两边的视图隐藏
        self.leftController?.view.hidden = true
        self.rightController?.view.hidden = true
        
        
        //添加滑动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        
        self.mainViewController?.view.addGestureRecognizer(pan)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMainViewAction), name: AutoLocationNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMainViewAction), name: ChooseLocationCityNotification, object: nil)
    }
    
    //MARK:***通知****
    
    func showMainViewAction(sender:NSNotification) {
        self.showMianView()
    }
    
    func panAction(sender:UIPanGestureRecognizer){
        
        //获取手指的位置
        let point = sender.translationInView(sender.view)
        
        self.condition_f = point.x * self.speed_f! + self.condition_f!
        
        if sender.view?.frame.origin.x >= 0 {
            sender.view?.center = CGPointMake((sender.view?.center.x)! + point.x * self.speed_f!, (sender.view?.center.y)!)
            
            sender.setTranslation(CGPointMake(0, 0), inView: self.view)
            
            self.rightController?.view.hidden = true
            self.leftController?.view.hidden = false
        } else {
            sender.view?.center = CGPointMake((sender.view?.center.x)! + point.x, (sender.view?.center.y)!)
            
            sender.setTranslation(CGPointMake(0, 0), inView: self.view)
            
            self.rightController?.view.hidden = false
            self.leftController?.view.hidden = true
        }
        //当手指离开屏幕时
        if sender.state == .Ended {
            if self.condition_f > UIScreen.mainScreen().bounds.width * CGFloat(0.5) * self.speed_f! {
                self.showLeftView()
            } else if self.condition_f < UIScreen.mainScreen().bounds.width * CGFloat(-0.5) * self.speed_f! {
                self.showRightView()
            } else {
                self.showMianView()
            }
        }
        
    }
    
    func showMianView() {
        UIView.beginAnimations(nil, context: nil)
        
        self.mainViewController?.view.center = CGPointMake(UIScreen.mainScreen().bounds.size.width/2, UIScreen.mainScreen().bounds.size.height/2)
        
        UIView.commitAnimations()
    }
    
    func showLeftView() {
        UIView.beginAnimations(nil, context: nil)
        
        self.mainViewController?.view.center = CGPointMake(UIScreen.mainScreen().bounds.size.width * CGFloat(1.5) - CGFloat(60), UIScreen.mainScreen().bounds.size.height/2)
        
        UIView.commitAnimations()
    }
    
    func showRightView() {
        UIView.beginAnimations(nil, context: nil)
        
        self.mainViewController?.view.center = CGPointMake(CGFloat(60) - UIScreen.mainScreen().bounds.size.width * CGFloat(0.5), UIScreen.mainScreen().bounds.size.height/2)
        
        UIView.commitAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

