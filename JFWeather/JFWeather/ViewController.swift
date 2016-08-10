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
    
    
    var speed_f:CGFloat?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.speed_f = 0.5
        
        //将主，左，右三个视图添加到窗口上
        let rootController = MainViewController()
        self.mainViewController = UINavigationController(rootViewController:rootController)
        self.view.addSubview((self.mainViewController?.view)!)
        
        self.leftController = LeftTableViewController()
        self.view.addSubview((self.leftController?.view)!)
        
        self.rightController = RightTableViewController()
        self.view.addSubview((self.rightController?.view)!)
        
        //将左右两边的视图隐藏
        self.leftController?.view.hidden = true
        self.rightController?.view.hidden = true
        
        
        //添加滑动手势
        let pan = UIPanGestureRecognizer(target: self, action: "panAction:")
        
        self.mainViewController?.view.addGestureRecognizer(pan)
    }
    
    func panAction(sender:UIPanGestureRecognizer){
        print("滑动屏幕")
        
        //获取手指的位置
        let point = sender.translationInView(sender.view)
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

