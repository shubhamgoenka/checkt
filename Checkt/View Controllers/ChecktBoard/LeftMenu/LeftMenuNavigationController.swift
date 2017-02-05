//
//  LeftMenuNavigationController.swift
//  Checkt
//
//  Created by Eliot Han on 11/17/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import SideMenu


//Don't Touch this File!!
class LeftMenuNavigationController: UISideMenuNavigationController{
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        self.navigationBar.barTintColor = Constants.grayThemeCol
        
        
        self.navigationController?.navigationBar.sizeToFit()
        AppState.hideStatusBar = true
        UIApplication.shared.setStatusBarHidden(true, with: .slide)


    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        AppState.hideStatusBar = false
        UIApplication.shared.setStatusBarHidden(false, with: .slide)

    }
    func hideMenu(){
        self.viewWillDisappear(true)
        //super.viewDidDisappear(true)
    }
    
}
