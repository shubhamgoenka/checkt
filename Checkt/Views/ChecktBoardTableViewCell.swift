//
//  ChecktBoardTableViewCell.swift
//  Checkt
//
//  Created by Shubham Goenka on 16/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit

class ChecktBoardTableViewCell: UITableViewCell {
    
    var eventPicImageView: UIImageView!
    var titleLabel: UILabel!
    var groupLabel: UILabel!
    var locationLabel: UILabel!
    var dateLabel: UILabel!
    var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        eventPicImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: Constants.width * (1/3), height: 25))
//        eventPicImageView.image 
        
        eventPicImageView = UIImageView(frame: CGRect(x: contentView.frame.height/14, y: contentView.frame.height/14, width: contentView.frame.height * 6/7, height: contentView.frame.height * 6/7))
        eventPicImageView.contentMode = .scaleAspectFill
        eventPicImageView.clipsToBounds = true
        contentView.addSubview(eventPicImageView)
        
        titleLabel = UILabel(frame: CGRect(x: contentView.frame.height * 13/14 + 30, y: contentView.frame.height/45, width: 100, height: 0.3*contentView.frame.height))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.numberOfLines = 1
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = UIFont(name: "Montserrat-Medium", size: 20)
        contentView.addSubview(titleLabel)
        
        groupLabel = UILabel(frame: CGRect(x: contentView.frame.height * 13/14 + 30, y: contentView.frame.height * 2/7 + 5, width: contentView.frame.width - contentView.frame.height * 13/14 - 60, height: contentView.frame.height/10))
        groupLabel.textColor = Constants.greenThemeCol
        groupLabel.adjustsFontSizeToFitWidth = true
        groupLabel.textAlignment = NSTextAlignment.left
        groupLabel.adjustsFontForContentSizeCategory = true
        groupLabel.numberOfLines = 1
        groupLabel.font = UIFont(name: "Montserrat-Light", size: 16)
        contentView.addSubview(groupLabel)
        
        locationLabel = UILabel(frame: CGRect(x: contentView.frame.height * 13/14 + 30, y: contentView.frame.height * 3/7 + 5, width: contentView.frame.width - contentView.frame.height * 13/14 - 60, height: contentView.frame.height * 13/140))
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.adjustsFontForContentSizeCategory = true
        locationLabel.textAlignment = NSTextAlignment.left
        locationLabel.numberOfLines = 1
        locationLabel.font = UIFont(name: "Montserrat-Light", size: 16)
        contentView.addSubview(locationLabel)
        
        dateLabel = UILabel(frame: CGRect(x: contentView.frame.height * 13/14 + 30, y: contentView.frame.height * 4/7 + 4, width: contentView.frame.width - contentView.frame.height * 13/14 - 60, height: contentView.frame.height * 3/35))
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = NSTextAlignment.left
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.numberOfLines = 1
        dateLabel.font = UIFont(name: "Montserrat-Light", size: 15)
        contentView.addSubview(dateLabel)
        
        timeLabel = UILabel(frame: CGRect(x: contentView.frame.height * 13/14 + 30, y: contentView.frame.height * 5/7 + 5, width: contentView.frame.width - contentView.frame.height * 13/14 , height: contentView.frame.height * 3/35))
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textAlignment = NSTextAlignment.left
        timeLabel.numberOfLines = 1
        timeLabel.adjustsFontForContentSizeCategory = true
        timeLabel.font = UIFont(name: "Montserrat-Light", size: 16)
        contentView.addSubview(timeLabel)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
