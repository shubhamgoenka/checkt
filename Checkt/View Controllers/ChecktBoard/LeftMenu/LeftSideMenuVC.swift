//
//  LeftSideMenuVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/17/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DZNEmptyDataSet

class LeftSideMenuVC: UIViewController, CAPSPageMenuDelegate{

    var pageMenu : CAPSPageMenu?
    // Array to keep track of controllers in page menu
    var controllerArray : [UIViewController] = []
    var dots: UIImageView = UIImageView()
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageMenu()
     
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageMenu?.hideTopMenuBar = true
    }
 
    func setupPageMenu(){
        let groupsVC = GroupsLeftMenuVC()
        //groupsVC.title = "Groups"
        controllerArray.append(groupsVC)
        
        let eventsVC = EventsLeftMenuVC()
        //eventsVC.title = "Events"
        controllerArray.append(eventsVC)
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(false),
            .menuItemSeparatorPercentageHeight(0.1),
            .viewBackgroundColor(UIColor.clear)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: view.frame, pageMenuOptions: parameters)
        pageMenu!.delegate = self
        pageMenu?.hideTopMenuBar = true
        self.view.backgroundColor = Constants.grayThemeCol
        self.view.addSubview(pageMenu!.view)
        
        
        //dots
        dots.image = UIImage(named: "pagecontrol1")
        dots.frame = CGRect(x: ((view.frame.width * 0.85)/2) - (35/2), y: view.frame.height * (8.5/9), width: 35, height: 14.0)
        view.addSubview(dots)
        

    }
    func didMoveToPage(_ controller: UIViewController, index: Int){
        if index == 0{
            dots.image = UIImage(named: "pagecontrol1")
        }else{
            dots.image = UIImage(named: "pagecontrol2")

        }
    }
    func hideMenu(){
        let nav = self.navigationController as? LeftMenuNavigationController
        nav?.hideMenu()
    }
}



