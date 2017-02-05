//
//  SearchVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/19/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import SwiftMessages


enum searchCategory{
    case groups
    case events
}

class SearchVC: UIViewController{
    var segmented: YSSegmentedControl!
    var searchController: UISearchController!
    var segmentedState: searchCategory?
    var dummyView: UIView!

    
    //var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
        setupSegmentedControl()
   
        edgesForExtendedLayout = []
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        DispatchQueue.main.async { [unowned self] in
            self.searchController.searchBar.becomeFirstResponder()
      
        }
    }
    
    
    func setupSegmentedControl(){
        segmented = YSSegmentedControl(
            frame: CGRect(
                x: 0,
                y: searchController.searchBar.frame.height + UIApplication.shared.statusBarFrame.height + 3,
                width: view.frame.size.width,
                height: 44),
            titles: [
                "Groups",
                "Events"
            ])
        segmented.appearance.bottomLineColor = UIColor.gray
        segmented.appearance.selectorColor = Constants.greenThemeCol
        segmented.appearance.selectorHeight = 5
        //change font here later
        
        segmentedState = searchCategory.groups
        
        segmented.delegate = self
        
        view.addSubview(segmented)
    }
    
    func setupSearch(){
        
        //dummy view - This is to prevent search bar from shifting down, a common ui bug
        dummyView = UIView(frame: CGRect(x: 0.0, y: UIApplication.shared.statusBarFrame.height + 1, width: view.frame.width, height: 45))
        view.addSubview(dummyView)
        
        
        //SearchController
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.isHidden = false
        
        searchController.definesPresentationContext = true

        searchController.searchBar.sizeToFit()
        // This following line fixed a bug for me where my search bar would not display
        searchController.searchBar.scopeButtonTitles = []
        
        
        //Customize searchbar
        searchController.searchBar.setImage(#imageLiteral(resourceName: "searchicon"), for: UISearchBarIcon.search, state: UIControlState.normal)
        searchController.searchBar.layer.cornerRadius =  3.0
        searchController.searchBar.clipsToBounds = true
        searchController.searchBar.layer.borderColor = UIColor.clear.cgColor
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: dummyView.frame.width, height: dummyView.frame.height)
        var textFieldInSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInSearchBar?.font = UIFont(name: "SF-UI-Text", size: 30)
        searchController.searchBar.placeholder = "Search for groups.."
        
        dummyView.addSubview(searchController.searchBar)

    }
    
    
//    func setupTableView(){
//        tableView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: view.frame.width, height: view.frame.height)
//        tableView = UITableView(frame: tableView.frame)
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length + 150, 0)  //this is to prevent tab bar from hiding last cell
//        
//        tableView.rowHeight = 80
//        tableView.backgroundColor = UIColor.white
//       //tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: "pokemonCell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.addSubview(tableView)
//    }

    
    func dismissVC(){
        dismiss(animated: true, completion: nil)
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
}

extension SearchVC: UISearchBarDelegate{
    
    //search button clicked on keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //searchController.searchBar.resignFirstResponder()
        
        //If searching for groups, else searching for events
        if segmentedState == .groups{
            Constants.dbRef.child("groups").child(searchBar.text!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get value
                var value: NSDictionary?
                //if val exists
                if let val = snapshot.value as? NSDictionary{
                    value = val
                    let foundGroup = Group(key: searchBar.text!, groupDict: value as! [String : AnyObject])
                    //Use this found event to get to eventCardScreen
                    let groupInfoVC = GroupInfoVC()
                    groupInfoVC.group = foundGroup
                    self.dismissVC()
                    self.present(groupInfoVC, animated: true, completion: nil)
                    
                } else { //val doesn't exist
                    let view = MessageView.viewFromNib(layout: .CardView)
                    view.configureDropShadow()
                    let iconText = "😕"
                    view.configureTheme(backgroundColor: UIColor.red, foregroundColor: UIColor.white)
                    view.button?.isHidden = true
                    view.configureContent(title: "Sorry,", body: "That group doesn't exist.", iconText:iconText)
                    
                   view.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                    var config = SwiftMessages.Config()
                    config.presentationStyle = .bottom
                    SwiftMessages.show(config: config, view: view)
                    
                    
                    
                }

            }) { (error) in
                print(error.localizedDescription)
                print("error1")
            }

        }else{
            //search for events
            Constants.dbRef.child("events").child(searchBar.text!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Get value
                var value: NSDictionary?
                if let val = snapshot.value as? NSDictionary{
                    value = val
                    let foundEvent = Event(key: searchBar.text!, eventDict: value as! [String : AnyObject])
                    //Use this found event to get to eventCardScreen
                    let eventInfoVC = EventInfoVC()
                    eventInfoVC.event = foundEvent
                    self.dismissVC()
                    self.present(eventInfoVC, animated: true, completion: nil)

                }
                else{
                    let view = MessageView.viewFromNib(layout: .CardView)
                    view.configureDropShadow()
                    let iconText = "🤔"
                    view.configureTheme(backgroundColor: Constants.greenThemeCol, foregroundColor: UIColor.white)
                    view.button?.isHidden = true
                    view.configureContent(title: "", body: "Hmmm, that event code might not exist...", iconText:iconText)
                    
                    view.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                    var config = SwiftMessages.Config()
                    config.presentationStyle = .bottom
                    SwiftMessages.show(config: config, view: view)
                    
                    
                }
                }) { (error) in

                    
                    
                print(error.localizedDescription)
                print("error2")
            }
        }
        
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //searchController.searchBar.frame = CGRect(x: 0, y: 0, width: dummyView.frame.width, height: dummyView.frame.height)

        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissVC()
    }
    
}

extension SearchVC: YSSegmentedControlDelegate{
    func segmentedControlDidPressedItemAtIndex(segmentedControl: YSSegmentedControl, index: Int) {
        if index == 0{
            segmentedState = .groups
            searchController.isActive = true
            DispatchQueue.main.async { [unowned self] in
                self.searchController.searchBar.becomeFirstResponder()
            }
            searchController.searchBar.text = nil
            searchController.searchBar.placeholder = "Search for groups.."


            SwiftMessages.hideAll()
            
        }else{
            segmentedState = .events
            
            searchController.isActive = true
            DispatchQueue.main.async { [unowned self] in
                self.searchController.searchBar.becomeFirstResponder()
            }
            searchController.searchBar.text = nil
            searchController.searchBar.placeholder = "Search for events using event codes..."

            SwiftMessages.hideAll()
        }
    }
}

//extension SearchVC: UITableViewDelegate, UITableViewDataSource{
//   
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let testCell: UITableViewCell = UITableViewCell()
//        return testCell
//        
//    }
//
//    
//}

