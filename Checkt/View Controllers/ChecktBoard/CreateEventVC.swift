
//  ViewController.swift
//  test
//
//  Created by Jessica Chen on 11/28/16.
//  Copyright © 2016 trainingprogram. All rights reserved.
//

import UIKit
import Bohr
import SwiftMessages

class CreateEventVC: BOTableViewController {
    
    var locationString: String?
    var location: Location?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightButton()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("create event vc appeared")
        setupDefaults()
        setupAppearance()
        
    }
    func setupRightButton(){
        //For right bar button
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        doneButton.titleLabel?.minimumScaleFactor = 0.6
        doneButton.frame = CGRect(x: 0, y: 0, width: 40, height: 35)
        doneButton.addTarget(self, action: #selector(self.addEventToFirebase), for: .touchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = doneButton
        self.navigationItem.rightBarButtonItem = rightButton
    }
    func addEventToFirebase(){
        var eventDict: [String: AnyObject] = [:]
        //s is section c is cell
        
        let s0 = self.sections[0] as! BOTableViewSection
        let s0c0 = s0.cells[0] as! BOTextTableViewCell
        let s0c1 = s0.cells[1] as! BOTextTableViewCell
        
        let s1 = self.sections[1] as! BOTableViewSection
        let s1c0 = s1.cells[0] as! BOButtonTableViewCell
        
        
        let s2 = self.sections[2] as! BOTableViewSection
        let s2c0 = s2.cells[0] as! BODateTableViewCell
        let s2c1 = s2.cells[1] as! BODateTableViewCell
        
        
        
        let eventName = (s0c0.textField?.text as String?)
        if eventName == ""{
            presentErrorMsg(string: "n event name/ID")
            return
        }
        
        let eventDescription = s0c1.textField?.text as String?
        if eventDescription == ""{
            self.presentErrorMsg(string: "n event description")
            return
        }
        
        print("The Location String: \(locationString)")
        if locationString == nil{
            presentErrorMsg(string: " location")
            return
        }
        guard let startTime = dateToString(date: s2c0.datePicker.date) as AnyObject? else{
            presentErrorMsg(string: " start check in time")
            return
        }
        guard let endTime = dateToString(date: s2c1.datePicker.date) as AnyObject? else{
            presentErrorMsg(string: "n End Time")
            return
        }
        if startTime as! String == endTime as! String{
            presentErrorMsg(string: " unique End Time")
            return
        }
        
        
        
        
        eventDict["eventName"] = eventName as AnyObject?
        eventDict["description"] = eventDescription as AnyObject?
        
        var regionDict: [String: AnyObject] = [:]

        regionDict["latitude"] = self.location?.coordinate.latitude as AnyObject?
        regionDict["longitude"] = self.location?.coordinate.longitude as AnyObject?
        regionDict["radius"] = self.location?.radius as AnyObject?
       // regionDict["eventType"] = self.location?.eventType as AnyObject?
        
      
    
       
        eventDict["region"] = regionDict as AnyObject?
        eventDict["startTime"] = dateToString(date: Date()) as AnyObject?   ///this should be starttime but ghetto testing
        eventDict["endTime"] = endTime
        eventDict["hostGroup"] = AppState.filteredGroup?.groupId as AnyObject?
        
        //Store eventDict using random codes
        let eventId = UUID().uuidString

        let eventRef = Constants.dbRef.child("events").child(eventId)
        eventRef.setValue(eventDict)
        print("Added event to firebase")
        
        let groupRef = Constants.dbRef.child("groups").child((AppState.filteredGroup?.groupId)!).child("futureEvents")
        print(groupRef)
        var upcomingEvents: [String] = []  //array of eventids
        groupRef.observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.exists() {
                if let eventsArray = snapshot.value as? [String] {
                    upcomingEvents = eventsArray 
                    upcomingEvents.append(eventId)
                    groupRef.setValue(upcomingEvents)
                    
                }
            } else {
                print("Group's first event")
                upcomingEvents.append(eventId)
                groupRef.setValue(upcomingEvents){ (error, snap) in
                    print(error)
                    print("Success in creating eventIds Array and adding to users groupIds in Firdatabase")
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }

                
            }
 
        })
        
     
       // eventRef.child("region").updateChildValues(regionDict)
        let event = Event(key: eventId, eventDict: eventDict)
        AppState.filteredGroup!.events.append(event)
        performSegue(withIdentifier: "unwindToAdminOptionsVC", sender: self)
        
    }
    
    func dateToString(date: Date) -> String{
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func presentErrorMsg(string: String){
        let view = MessageView.viewFromNib(layout: .CardView)
        view.configureDropShadow()
        let iconText = "🤔"
        view.configureTheme(backgroundColor: Constants.orangeThemeCol, foregroundColor: UIColor.white)
        view.button?.isHidden = true
        view.configureContent(title: "", body: "You're missing a\(string)...", iconText:iconText)
        view.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        SwiftMessages.show(config: config, view: view)
    }
    
    override func setup(){
        self.title = "Create an Event"
        self.addSection(BOTableViewSection(headerTitle: "Event Info", handler: {(_ section: BOTableViewSection?) -> Void in
            section?.addCell(BOTextTableViewCell(title: "Event name", key: "name", handler: { (_ cell: Any?) -> Void in
                let cell = cell as! BOTextTableViewCell
                cell.textField.text = nil
                cell.textField.placeholder = "Name"
            }))
            section?.addCell(BOTextTableViewCell(title: "Event description", key: "desc", handler: { (_ cell: Any?) -> Void in
                let cell = cell as! BOTextTableViewCell
                cell.textField.text = nil
                cell.textField.placeholder = "Description"
                //(cell as! BOTextTableViewCell).minimumTextLength = 20
                
            }))
        }))
        
        self.addSection(BOTableViewSection(headerTitle: "Location Info", handler: {(_ section: BOTableViewSection?) -> Void in
            section?.addCell(BOButtonTableViewCell(title: "Location", key: nil, handler: {(_ cell: Any?) -> Void in
                (cell as! BOButtonTableViewCell).actionBlock = {() -> Void in
                    print("this works")
                    self.performSegue(withIdentifier: "segueToMapVC", sender: self)
                }
            }))
        }))
        
        self.addSection(BOTableViewSection(headerTitle: "Event Time", handler: {(_ section: BOTableViewSection?) -> Void in
            
            section?.addCell(BODateTableViewCell(title: "Check-in Start Time", key: "startTime", handler: {(_ cell: Any?) ->
                Void in
                let date = Date(dateString:"2014-06-06")
                print(date)
                let c = cell as! BODateTableViewCell
                c.datePicker.date = date
                (cell as! BODateTableViewCell).datePicker.minuteInterval = 5
                (cell as! BODateTableViewCell).datePicker.datePickerMode = .dateAndTime
                //set end date to be after the startDate
            }))
            section?.addCell(BODateTableViewCell(title: "Check-in End Time", key: "endTime", handler: {(_ cell: Any?) ->
                Void in
                (cell as! BODateTableViewCell).datePicker.minuteInterval = 5
                (cell as! BODateTableViewCell).datePicker.datePickerMode = .dateAndTime
                //set end date to be after the startDate
            }))
        }))
        
    }
    
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    
    func setupDefaults() {
        UserDefaults.standard.register(defaults: ["name": "", "desc": "", "startTime": Date(), "endTime": Date()])
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapVC"{
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
        
    }
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MapVC {
            locationString = (sourceViewController.locationStringPassed!)
            location = sourceViewController.locationPassed
            let sect = self.sections[1] as! BOTableViewSection
            let cell = sect.cells[0] as! BOButtonTableViewCell
            cell.textLabel?.text = locationString
        }
    }
}

extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
}
