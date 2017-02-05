//
//  ChecktboardVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/16/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import DZNEmptyDataSet
import SideMenu
import NVActivityIndicatorView

import CoreLocation





class ChecktBoardVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView! = UITableView()
    var userPinnedEvents: [Event] = []
    var userGroups: [Group] = []
    var upcomingEvents: [Event] = []
    var groupImageUrl = ""
    
    var hasGroupsButNoUpcomingEvents: Bool = false  //currently not used but will be used - reminder for eliot
    
    var loadingView: NVActivityIndicatorView?
    

    var showLeftSideMenuButton = UIButton() //only this button is created in global frame so i can turn userinteractivity on this off while loading database

    var locationManager = CLLocationManager()
    var locations: [Location] = []

    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    // For DZN Empty DataSet
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuickUI()
        
        //configureAppState() makes sure the AppState and info for the user is loaded before displaying anything
        
        // 1
        locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()
        // 3
        loadAllGeotifications()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view appeear")
        load()
        if AppState.hasFiltered{
//            upcomingEvents.removeAll()
//            for event in AppState.upcomingEvents{
//                print(event.name)
//                self.upcomingEvents.append(event)
//            }
            SideMenuManager.menuEnableSwipeGestures = false
            performSegue(withIdentifier: "segueToFilteredVC", sender: self)
        }else{
            SideMenuManager.menuEnableSwipeGestures = true

        }
      

        
    }
    
    
    // MARK: Side Menu
    func setupSideMenus(){
        //left menu
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? LeftMenuNavigationController
        menuLeftNavigationController?.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        
        //right menu
        let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? RightMenuNavigationController
        menuRightNavigationController?.leftSide = false
        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        
        //gestures
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        //customization
        SideMenuManager.menuAnimationBackgroundColor = UIColor.white
        SideMenuManager.menuShadowOpacity = 0.5
        SideMenuManager.menuAnimationFadeStrength = 0.5
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuWidth = view.frame.width * 0.85
        //Constants.menuNavBarWidth = view.frame.width * 0.85  //not used
        
        
    }
    
    func showLeftSideMenu(){
        SideMenuManager.menuPresentMode = .viewSlideOut
        present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
        
    }
    func showRightSideMenu(){
        SideMenuManager.menuPresentMode = .menuSlideIn
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
        
    }
    
    // MARK: UI for Icons
    func setupButtons(){
        showLeftSideMenuButton.setImage(#imageLiteral(resourceName: "leftmenu"), for: .normal)
        showLeftSideMenuButton.tintColor = UIColor.white
        showLeftSideMenuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        showLeftSideMenuButton.addTarget(self, action: #selector(ChecktBoardVC.showLeftSideMenu), for: .touchUpInside)
        let sideMenuButton = UIBarButtonItem()
        sideMenuButton.customView = showLeftSideMenuButton
        sideMenuButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = sideMenuButton
        showLeftSideMenuButton.isUserInteractionEnabled = false
        
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 27))
        searchButton.setImage(#imageLiteral(resourceName: "Search Icon"), for: .normal)
        searchButton.addTarget(self, action:  #selector(ChecktBoardVC.showSearchVC), for: .touchUpInside)
        let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
        searchButton.tintColor = UIColor.white
        
        
        let showRightSideMenuButton = UIButton()
        showRightSideMenuButton.setImage(#imageLiteral(resourceName: "RightNavBar Icon"), for: .normal)
        showRightSideMenuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        showRightSideMenuButton.addTarget(self, action: #selector(ChecktBoardVC.showRightSideMenu), for: .touchUpInside)
        let userMenuButton = UIBarButtonItem()
        userMenuButton.tintColor = UIColor.white
        userMenuButton.customView = showRightSideMenuButton
        self.navigationItem.setRightBarButtonItems([userMenuButton, searchBarButtonItem], animated: true)
        
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.00, green:0.62, blue:0.57, alpha:1.0)
        
    }
    
    // MARK: - Table View
    
    func setupTableView(){
        tableView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!, width: view.frame.width, height: view.frame.height) //height of navigation bar + statusbar
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
        //print("Number of groups is \(AppState.currentUser!.groupIds.count)")
        //print("Number of upcoming events is \(AppState.currentUser!.upcomingEvents.count)")
        
        if (AppState.currentUser!.groupIds.count) != 0{
            if AppState.currentUser!.upcomingEvents.count == 0{
                hasGroupsButNoUpcomingEvents = true
                return 0
            }else{
                return self.upcomingEvents.count
            }
            
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ChecktBoardTableViewCell
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        cell.eventPicImageView.image = #imageLiteral(resourceName: "defaultGroupPic")
        let event = self.upcomingEvents[indexPath.row]

               //cell.locationLabel.text = event.
        
//        print("AAAAA\(event.hostGroup)")
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ChecktBoardTableViewCell
        let event = self.upcomingEvents[indexPath.row]
        cell.titleLabel.text = event.name
        cell.groupLabel.text = event.hostGroup
        cell.dateLabel.text = event.date
        cell.timeLabel.text = "\(event.startTime) ~ \(event.endTime)"
        cell.locationLabel.text = event.location["location"] as! String?

        //cell.locationLabel.text = event.
        

        
        //cell.timeLabel.text = event.date
        
       

               
    }
    
    func getGroupImage(withBlock: @escaping (UIImage) -> Void) {
        print(groupImageUrl)
        if (groupImageUrl != "") {
            let obtainURL = URL(string: groupImageUrl)
            if let picChosen = NSData(contentsOf: obtainURL!){
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
    }
    
    func displayGroupPic(withBlock: @escaping (UIImage) -> Void) {
        
        if (AppState.currentUser?.groups != nil) {
            // Obtain URL from the FIRDatabase reference
            // postPhoto URL
            let obtainURL = NSURL(string: (AppState.currentUser?.userImageUrl)!)
            // this URL convert into Data
            let picChosen = NSData(contentsOf: obtainURL as! URL)
            
            if picChosen != nil {
                let image = UIImage(data: picChosen as! Data)
                withBlock(image!)
            } else {
                print("An error occured while retrieving your uploaded picture")
                let image = #imageLiteral(resourceName: "tempProfile")
                withBlock(image)
            }
        }
    }

    
    //MARK: Show Search
    func showSearchVC(){
        performSegue(withIdentifier: "segueToSearchVC", sender: self)
    }
    
    
    // MARK: Database
    //you only need to call load for the database stuff, it configures app state and database
    func load(){
        AppState.currentUser?.groups.removeAll()
        configureAppState(withBlock: {
            self.configureDatabase()
        })
    }
    
    func configureAppState(withBlock: @escaping () -> Void){
        print("Configuring app state")
        let uid  = FIRAuth.auth()?.currentUser?.uid
        print(uid as Any)
        Constants.dbRef.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get value
            var value: NSDictionary?
            if let val = snapshot.value as? NSDictionary{
                print("Got value while configuring app state")
                value = val
                AppState.currentUser = User(key: uid!, userDict: value as! [String: AnyObject])
                print(AppState.currentUser!.uid)
            }else{
                print("User ID does not exist in database")
                
            }
            withBlock() //this should be configureDatabase()

        }) { (error) in
            print(error.localizedDescription)
            print("Error configuring App State")
        }
    }
    
    func configureDatabase(){
        print("Configuring database")
        AppState.currentUser?.setup(withBlock: {
            self.upcomingEvents = (AppState.currentUser?.upcomingEvents)!
            self.setupUIAfterConfig()
        })
    }
    
    
    //MARK: UI
    
    //UI setup as soon as app opens
    func setupQuickUI(){
        self.setupSideMenus()
        self.setupButtons()
        loadingView = NVActivityIndicatorView(frame: CGRect(x: view.frame.width/2 - 22, y: view.frame.height/2, width: 44, height: 44))
        loadingView?.color = Constants.greenThemeCol
        loadingView?.type = .ballRotateChase
        loadingView?.startAnimating()
        view.addSubview(loadingView!)
        
        
        
        //for title label
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "Montserrat-Light", size: 20)!]
        self.navigationItem.title = "Checktboard"
        
    }
    
    
    //This is ui that should be setup after the database configured finishes
    func setupUIAfterConfig(){
        loadingView?.stopAnimating()
        self.setupTableView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
        showLeftSideMenuButton.isUserInteractionEnabled = true  //not that appstate is configured, 
        
    }
    //This is to set backbar button ui in filteredvc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFilteredVC"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
    }

}


// MARK: - DZNEmpty Data Set
extension ChecktBoardVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Checktboard logo Green")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        if hasGroupsButNoUpcomingEvents{
            let text = "Welcome back!"
            return NSAttributedString(string: text, attributes: attribs)
        }else{
            let text = "Welcome to Checkt!"
            return NSAttributedString(string: text, attributes: attribs)
        }
        
       
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName: UIColor.darkGray,
            NSParagraphStyleAttributeName: para
        ]
        
        
        if hasGroupsButNoUpcomingEvents{
            let text = "Your groups have no upcoming events."
            return NSAttributedString(string: text, attributes: attribs)
            
        }else{
            let text = "Search for events to pin and groups to join."
            return NSAttributedString(string: text, attributes: attribs)

        }
    }
    
    
}


// MARK: - Location Manager Delegate and stuff
extension ChecktBoardVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    
    func region(withGeotification geotification: Location) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Location) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(Title:"Error", Message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(Title:"Warning", Message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Location) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func showAlert(Title: String, Message: String) {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        guard let savedItems = UserDefaults.standard.array(forKey: "savedItems") else { return }
        for savedItem in savedItems {
            guard let location = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Location else { continue }
            locations.append(location)
        }
    }
    
    func saveAllGeotifications() {
        var items: [Data] = []
        for location in locations {
            let item = NSKeyedArchiver.archivedData(withRootObject: location)
            items.append(item)
        }
        UserDefaults.standard.set(items, forKey: "savedItems")
    }
    
}




