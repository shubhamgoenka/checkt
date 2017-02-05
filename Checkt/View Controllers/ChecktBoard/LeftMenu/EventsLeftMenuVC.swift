//
//  EventsLeftMenuVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/20/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DZNEmptyDataSet

class EventsLeftMenuVC: UIViewController{
    var tableView: UITableView! = UITableView()
    var createGroupsButton: UIButton?
    
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
        tableView.reloadData()
    }
    
    
    func setupTableView(){
        tableView.frame = CGRect(x: 0, y: 25, width: view.frame.width * 0.85, height: view.frame.height * (8.5/9))
        tableView = UITableView(frame: tableView.frame)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length + 150, 0)  //this is to prevent tab bar from hiding last cell
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.backgroundColor = UIColor.clear
        tableView.register(EventLeftMenuTableViewCell.self, forCellReuseIdentifier: "eventCell")
        //tableView.clearsselection
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine

        
        view.addSubview(tableView!)
    }
    
    func setupUI(){
        view.backgroundColor = Constants.grayThemeCol
        
        
    }
}


extension EventsLeftMenuVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppState.currentUser?.pinnedEvents.count == 0{
            return 0
        }else{
            return (AppState.currentUser?.pinnedEvents.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventLeftMenuTableViewCell
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        return cell
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! EventLeftMenuTableViewCell
        let event = AppState.currentUser?.pinnedEvents[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.eventLabel.text = event?.name
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //make cell orange on selection
        let cell: EventLeftMenuTableViewCell = tableView.cellForRow(at: indexPath) as! EventLeftMenuTableViewCell
        cell.contentView.backgroundColor = Constants.orangeThemeCol
    }
}


// MARK: - DZNEmpty Data Set
extension EventsLeftMenuVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -200.0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You have no events!"
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
        let text = "Pinned events will show up here."
        
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
    
    
}


