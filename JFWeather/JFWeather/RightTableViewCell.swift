//
//  RightTableViewCell.swift
//  JFWeather
//
//  Created by 杨凡 on 16/8/17.
//  Copyright © 2016年 yf. All rights reserved.
//

import UIKit

class RightTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var deleteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = leftControllerAndRightControllerBGColor
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
