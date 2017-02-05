//
//  Constants.swift
//  Checkt
//
//  Created by Eliot Han on 11/12/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import Firebase


struct Constants {
    
    static let dbRef = FIRDatabase.database().reference()
    static let storageRef = FIRStorage.storage().reference()

    //static var menuNavBarWidth: CGFloat?
    
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height


    
    //static var menuNavBarWidth: CGFloat?
    static let defaultM: UIFont = UIFont(name: "Montserrat-Medium", size: 20)!
    static let defaultEL: UIFont = UIFont(name: "Montserrat-ExtraLight", size: 20)!
    static let defaultL: UIFont = UIFont(name: "Montserrat-Light", size: 20)!
    static let greenThemeCol = UIColor(red: 0.00, green: 0.62, blue: 0.57, alpha: 1.0)
    static let orangeThemeCol = UIColor(red: 0.96, green: 0.43, blue: 0.23, alpha: 1.0)
    static let grayThemeCol = UIColor(red:0.29, green:0.29, blue:0.29, alpha:0.7)}
