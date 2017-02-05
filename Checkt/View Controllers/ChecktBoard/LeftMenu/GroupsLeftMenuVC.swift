//
//  Checkt
//
//  Created by Eliot Han on 11/17/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DZNEmptyDataSet

class GroupsLeftMenuVC: UIViewController{
    var tableView: UITableView! = UITableView()
    var createGroupsButton: UIButton?
    
    var groups: [Group] = []
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // For DZN Empty DataSet
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("groups left menu tableview vc appeared")
        tableView.reloadData()
        
    }
    
    func setupTableView(){
        tableView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 5, width: view.frame.width * 0.85, height: view.frame.height * (6.5/9))
        tableView = UITableView(frame: tableView.frame)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length + 150, 0)  //this is to prevent tab bar from hiding last cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = UIColor.clear

        tableView.register(GroupLeftMenuTableViewCell.self, forCellReuseIdentifier: "groupCell")
       
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine

        view.addSubview(tableView!)
    }
    
    func setupUI(){
        view.backgroundColor = Constants.grayThemeCol
        
        
        //Create Groups button
        let buttonWidth = (view.frame.width * 0.85) * 0.9 //Due to side menu pod numbers
        createGroupsButton = UIButton(frame: CGRect(x: 15, y: tableView.frame.maxY, width: buttonWidth, height: (view.frame.height/9) - 10))
        
        createGroupsButton?.setImage(#imageLiteral(resourceName: "createanewgroup"), for: .normal)
        //createGroupsButton?.setImage
        createGroupsButton?.addTarget(self, action: #selector(tappedCreate), for: .touchUpInside)
        view.addSubview(createGroupsButton!)
        createGroupsButton?.addTarget(self, action: #selector(createGroupPressed), for: .touchUpInside)

        
    }
    
    func createGroupPressed(){
        let createGroupVC: UIViewController = UIStoryboard(name: "Checktboard", bundle: nil).instantiateViewController(withIdentifier: "CreateGroupVC") as UIViewController
        self.present(createGroupVC, animated: true, completion: nil)
    }
}


extension GroupsLeftMenuVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppState.currentUser?.groups.count == 0{
            return 0
        }else{
            print(AppState.currentUser?.groups.count, "-> number of groups")
            return (AppState.currentUser?.groups.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupLeftMenuTableViewCell
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        return cell

    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! GroupLeftMenuTableViewCell
        let group = AppState.currentUser?.groups[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.groupLabel.text = "#\(group!.groupId)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenGroup =  AppState.currentUser?.groups[indexPath.row]
        let filteredEvents = chosenGroup?.events
        AppState.upcomingEvents.removeAll()
        AppState.hasFiltered = true
        for event in filteredEvents!{
            AppState.upcomingEvents.append(event)
        }
        AppState.filteredGroup = chosenGroup
        
        //make cell orange on selection
        let cell: GroupLeftMenuTableViewCell = tableView.cellForRow(at: indexPath) as! GroupLeftMenuTableViewCell
        cell.contentView.backgroundColor = Constants.orangeThemeCol
        
//        let nav = self.parent?.parent as? LeftSideMenuVC
//        print(nav, "hey")
        
    }
    
//    func saveEventArrayData(_ events: [Event]) {
//        var mutableDataArray: NSMutableArray = []
//        for event in events{
//            mutableDataArray.add(event)
//        }
//        var archiveArray = [Any]() /* capacity: mutableDataArray.count */
//        for event in mutableDataArray {
//            var encodedEvent = NSKeyedArchiver.archivedData(withRootObject: event)
//            archiveArray.append(encodedEvent)
//        }
//        var userData = UserDefaults.standard
//        userData.set(archiveArray, forKey: "filteredEvents")
//    }
    
}


// MARK: - DZNEmpty Data Set
extension GroupsLeftMenuVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -150
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You have no groups!"
        let para = NSMutableParagraphStyle()
        para.alignment = NSTextAlignment.left
        
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: para
            
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Joined groups will show up here."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.left
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    
    func tappedCreate() {
        let createGroupVC = CreateGroupVC()
        self.present(createGroupVC, animated: true, completion: nil)
    }
    
}


