//
//  RightMenuNavigationController.swift
//  Checkt
//
//  Created by Eliot Han on 11/19/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import SideMenu


//Don't Touch this File!!
class RightMenuNavigationController: UISideMenuNavigationController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationBar.isHidden = true
        AppState.hideStatusBar = true
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        AppState.hideStatusBar = false
        UIApplication.shared.setStatusBarHidden(false, with: .slide)
        
    }
    
}
