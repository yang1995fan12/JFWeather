//
//  MainTableViewCell.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/20.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var animationImageView: UIImageView!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var current_temp_label: UILabel!
    
    @IBOutlet weak var range_temp_label: UILabel!
    
    @IBOutlet weak var windImageView: UIImageView!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var humidityImageView: UIImageView!
    
    @IBOutlet weak var range_humidity_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //将选中状态改为没有
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
