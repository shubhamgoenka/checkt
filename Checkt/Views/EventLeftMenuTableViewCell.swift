//
//  EventLeftMenuTableViewCell.swift
//  Checkt
//
//  Created by Eliot Han on 11/27/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit

class EventLeftMenuTableViewCell: UITableViewCell{
    
    var eventLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventLabel = UILabel(frame: CGRect(x: 15, y: contentView.frame.height/4 - 3, width: contentView.frame.width * 0.75, height: contentView.frame.height * 0.75 + 3))
        eventLabel.font = UIFont(name: "Montserrat-Light", size: 14)
        eventLabel.textColor = UIColor.white

        contentView.addSubview(eventLabel)
       
        contentView.backgroundColor = UIColor.clear

    }
    
    
}
