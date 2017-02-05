//
//  RightSideMenuTableViewCell.swift
//  Checkt
//
//  Created by Rochelle on 11/25/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit

class RightSideMenuTableViewCell: UITableViewCell {
    
    var leftIcon: UIImageView!
    var centerTitle: UILabel!
    var screenWidth = UIScreen.main.bounds.width * 0.85
    var screenHeight = UIScreen.main.bounds.height
    

    override func awakeFromNib() {
        super.awakeFromNib()

        leftIcon = UIImageView(frame: CGRect(x: screenWidth * (1/4), y: ((1/11) * screenHeight) / 2, width: 30, height: 30))
        leftIcon.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(leftIcon)
        
        centerTitle = UILabel(frame: CGRect(x: (screenWidth * (1/4)) + 60, y: ((1/11) * screenHeight) / 2, width: screenWidth * 0.7, height: 30))
        centerTitle.font = UIFont(name: "Montserrat-Light", size: 15)
        centerTitle.textColor = UIColor.black
        centerTitle.textAlignment = .left
        contentView.addSubview(centerTitle)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
