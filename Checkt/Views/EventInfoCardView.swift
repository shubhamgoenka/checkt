//
//  EventInfoCardView.swift
//  Checkt
//
//  Created by Shubham Goenka on 23/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit

class EventInfoCardView: UIView {

    var cornerRadius: CGFloat = 20
    var shadowOffsetWidth: Int = 10
    var shadowOffsetHeight: Int = 10
    var shadowColor: CGColor = UIColor.black.cgColor
    var shadowOpacity: Float = 0.5
    var borderRadius: CGFloat = 20
    var borderColor: CGColor = UIColor(red: 0.96, green: 0.43, blue: 0.23, alpha: 1.0).cgColor
    
    override func layoutSubviews() {
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
    }
    
}
