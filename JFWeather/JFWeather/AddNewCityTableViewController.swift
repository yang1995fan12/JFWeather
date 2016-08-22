//
//  AddNewCityTableViewController.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/22.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class AddNewCityTableViewController: UITableViewController {

    var default_citys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()

        let path = NSBundle.mainBundle().pathForResource("default-city", ofType: "plist")
        let array = NSArray(contentsOfFile:path!)
        for element in array! {
            self.default_citys.append(element as! String)
        }
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        
        //去掉表格的分割线
        self.tableView.separatorStyle = .None
        
        //添加搜索框
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        headerView.backgroundColor = UIColor.blackColor()
        
        let search_tf = UITextField(frame: CGRectMake(20, 14, self.view.frame.size.width-40, 30))
        search_tf.backgroundColor = UIColor.whiteColor()
        search_tf.layer.cornerRadius = 15
        search_tf.layer.masksToBounds = true
        
        search_tf.leftView = UIImageView(image: UIImage(named: "search_b"))
        search_tf.leftViewMode = .Always
        headerView.addSubview(search_tf)
        
        search_tf.placeholder = "城市名称或拼音"
        
        self.tableView.tableHeaderView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.default_citys.count + 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        cell.backgroundColor = UIColor.blackColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "自动定位"
            cell.imageView?.image = UIImage(named: "city")
        } else {
            cell.textLabel?.text = self.default_citys[indexPath.row - 1]
           
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    override func tableView(tableView:UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
            NSNotificationCenter.defaultCenter().postNotificationName(AutoLocationNotification, object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(ChooseLocationCityNotification, object: nil, userInfo: ["choose_city":self.default_citys[indexPath.row - 1]])
        }
        //
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    //隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
