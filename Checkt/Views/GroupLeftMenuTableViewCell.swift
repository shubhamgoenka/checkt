//
//  GroupLeftMenuTableViewCell.swift
//  Checkt
//
//  Created by Eliot Han on 11/22/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit


class GroupLeftMenuTableViewCell: UITableViewCell{
    
    var groupLabel: UILabel!
    var adminImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupLabel =  UILabel(frame: CGRect(x: 15, y: contentView.frame.height/4 - 3, width: contentView.frame.width * 0.75, height: contentView.frame.height * 0.75 + 3))
        groupLabel.font = UIFont(name: "Montserrat-Light", size: 13)
        groupLabel.textColor = UIColor.white
        contentView.addSubview(groupLabel)
        
        contentView.backgroundColor = UIColor.clear
//        adminImageView = UIImageView(frame: CGRect(x: (contentView.frame.width * 0.85) - 25, y: contentView.frame.height/4, width: contentView.frame.height * (0.75), height: contentView.frame.height * (0.75)))
//        contentView.addSubview((adminImageView?)
    }
    
    
}
