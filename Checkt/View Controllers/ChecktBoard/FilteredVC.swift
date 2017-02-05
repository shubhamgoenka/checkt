//
//  FilteredEventsVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/29/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//
import Foundation
import UIKit
import DZNEmptyDataSet

class FilteredVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView! = UITableView()
    
    let currUser = AppState.currentUser
    var groupImageUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
        
    }
    
    // For DZN Empty DataSet
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        AppState.hasFiltered = false  //required
    }
    
    func setupUI(){
        //for title label
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Montserrat-Light", size: 20)!]
        self.navigationItem.title = AppState.filteredGroup?.groupId
        
        setupAdminButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupAdminButton(){
        //if admin setup adminbutton
        if currUser?.uid == AppState.filteredGroup?.admins[0]{
            let adminButton = UIButton()
            adminButton.setImage(#imageLiteral(resourceName: "Crown"), for: .normal)
            adminButton.tintColor = UIColor.white
            adminButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            adminButton.addTarget(self, action: #selector(self.showAdminOptions), for: .touchUpInside)
            let rightButton = UIBarButtonItem()
            rightButton.customView = adminButton
            rightButton.tintColor = UIColor.yellow
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func showAdminOptions(){
        performSegue(withIdentifier: "segueToAdminOptionsVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAdminOptionsVC"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
    }

    
    
    
    //MARK: tableview
    func setupTableView(){
        tableView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.frame.width, height: view.frame.height) //height of navigation bar + statusbar
        tableView = UITableView(frame: tableView.frame)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length + 150, 0)  //this is to prevent tab bar from hiding last cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = Constants.height / 5

        tableView.register(ChecktBoardTableViewCell.self, forCellReuseIdentifier: "eventCell")
        view.addSubview(tableView!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("number of filtered group's events", AppState.filteredGroup!.events.count)
        return (AppState.filteredGroup!.events.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ChecktBoardTableViewCell
        let event = AppState.filteredGroup!.events[indexPath.row]
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.eventPicImageView.image = #imageLiteral(resourceName: "defaultGroupPic")

        if event.hostGroup != nil{
            Constants.dbRef.child("groups").child(event.hostGroup).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get value
                var value: NSDictionary?
                let val = snapshot.value as? NSDictionary
                self.groupImageUrl = (val?["groupImageURL"] as? String)!
                self.getGroupImage(withBlock: {retrievedImage -> Void in
                    cell.eventPicImageView.image = retrievedImage
                })
            })
            
        } else{
            cell.eventPicImageView.image = #imageLiteral(resourceName: "defaultGroupPic")
        }

        
        return cell
        
    }
    func getGroupImage(withBlock: @escaping (UIImage) -> Void) {
        if (groupImageUrl != "") {
            let obtainURL = NSURL(string: groupImageUrl)
            let picChosen = NSData(contentsOf: obtainURL as! URL)
            if picChosen != nil {
                let image = UIImage(data: picChosen as! Data)
                withBlock(image!)
            } else {
                print("An error occured while retrieving group profile picture")
                let image = #imageLiteral(resourceName: "defaultGroupPic")
                withBlock(image)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ChecktBoardTableViewCell
        let event = AppState.filteredGroup!.events[indexPath.row]
        cell.titleLabel.text = event.name
        cell.groupLabel.text = event.hostGroup
        cell.dateLabel.text = event.date
        cell.timeLabel.text = "\(event.startTime) ~ \(event.endTime)"
        cell.locationLabel.text = event.location["location"] as! String?
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}


// MARK: - DZNEmpty Data Set
extension FilteredVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -100
    }
    

    
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no events")
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "This group has no events!"
        let para = NSMutableParagraphStyle()
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.black,
            NSParagraphStyleAttributeName: para
            
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    //    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    //        let text = "Joined groups will show up here."
    //
    //        let para = NSMutableParagraphStyle()
    //        para.lineBreakMode = NSLineBreakMode.byWordWrapping
    //        para.alignment = NSTextAlignment.left
    //
    //        let attribs = [
    //            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
    //            NSForegroundColorAttributeName: UIColor.black,
    //            NSParagraphStyleAttributeName: para
    //        ]
    //
    //        return NSAttributedString(string: text, attributes: attribs)
    //    }
    
    
    
    
}

