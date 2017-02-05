//
//  AdminOptionsVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/29/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit
import Bohr

class AdminOptionsVC: BOTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDefaults()
        setupAppearance()
    }
    
    func setupUI(){
        //For right bar button
        let addEventButton = UIButton()
        addEventButton.setImage(#imageLiteral(resourceName: "create event button"), for: .normal)
        addEventButton.tintColor = Constants.orangeThemeCol
        addEventButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        addEventButton.addTarget(self, action: #selector(self.showCreateEventVC), for: .touchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = addEventButton
        rightButton.tintColor = Constants.orangeThemeCol
        self.navigationItem.rightBarButtonItem = rightButton
   
        //for nav title
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Montserrat-Light", size: 20)!]
        self.navigationItem.title = "Admin Options"
    }
    
    override func setup(){
        self.addSection(BOTableViewSection(headerTitle: AppState.filteredGroup!.groupId, handler: {(_ section: BOTableViewSection?) -> Void in
            section?.addCell(BOTableViewCell(title: AppState.filteredGroup!.description, key: "groupDesc", handler: nil))
        }))
        self.addSection(BOTableViewSection(headerTitle: "View", handler: {(_ section: BOTableViewSection?) -> Void in
            section?.addCell(BOButtonTableViewCell(title: "Members", key: nil, handler: {(_ cell: Any?) -> Void in
                (cell as! BOButtonTableViewCell).actionBlock = {() -> Void in
                    print("see members works")
                }
            }))
            section?.addCell(BOButtonTableViewCell(title: "Events", key: nil, handler: {(_ cell: Any?) -> Void in
                (cell as! BOButtonTableViewCell).actionBlock = {() -> Void in
                    print("events works")
                }
            }))
        }))
    }
    func setupDefaults() {
        UserDefaults.standard.register(defaults: ["groupDesc": ""])
    }
    
    func setupAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = Constants.greenThemeCol
        UINavigationBar.appearance().tintColor = Constants.greenThemeCol
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UITableView.appearance().backgroundColor = UIColor(white: CGFloat(0.95), alpha: CGFloat(1))
        
        
        BOTableViewSection.appearance().headerTitleColor = UIColor.gray
        BOTableViewSection.appearance().footerTitleColor = UIColor.lightGray
        BOTableViewCell.appearance().mainColor = UIColor.darkGray
        BOTableViewCell.appearance().secondaryColor = Constants.greenThemeCol
        BOTableViewCell.appearance().selectedColor = Constants.orangeThemeCol
    }
    
    func showCreateEventVC(){
        performSegue(withIdentifier: "segueToCreateEventVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCreateEventVC"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
    }

    @IBAction func unwindToAdminOptions(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreateEventVC {
           
        }
    }

    
    
}
