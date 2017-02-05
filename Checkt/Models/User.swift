//
//  User.swift
//  Checkt
//
//  Created by Shubham Goenka on 12/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import Firebase


enum loginStatus {
    case loggedIn
    case loggedOut
}


class User {
    
    var uid: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var userImageUrl: String = ""
    var groupIds: [String] = []
    var pinnedEventIds: [String] = []
    var pastEvents: [String] = []
    
    var groups: [Group] = []
    var pinnedEvents: [Event] = []
    var upcomingEvents: [Event] = []
    
    
    init (key: String, userDict: [String: AnyObject]) {
        uid = key
        if let first = userDict["firstName"] as? String {
            firstName = first
        }
        if let last = userDict["lastName"] as? String {
            lastName = last
        }
        if let emailID = userDict["email"] as? String {
            email = emailID
        }
        if let profPicUrl = userDict["downloadURL"] as? String {
            userImageUrl = profPicUrl
        }
        if let groups = userDict["groupIds"] as? [String] {
            groupIds = groups
        }
        if let pinned = (userDict["pinnedEvents"] as? [String]) {  //these are pinnedEventIds
            pinnedEventIds = pinned
        }
        if let past = (userDict["pastEvents"] as? [String]) {
            pastEvents = past
        }
    }
    
    
//    func getUserImage(withBlock: @escaping (UIImage) -> Void) {
//        //let imageRef = (Constants.storageRef.child(userImageUrl))
//        //print("image ref : \(imageRef)")
//        print ("user imageurl \(AppState.currentUser!.userImageUrl)")
//        AppState.currentUser!.userImageUrl.data(using: 1 * 1024 * 1024) { (data, error) in
//            if error != nil {
//                print("An error occured while retrieving user image: \(error)")
//            } else {
//                let image = UIImage(data: data!)
//                withBlock(image!)
//            }
//        }
//    }
    
    
    func displayProfPic(withBlock: @escaping (UIImage) -> Void) {
        if (AppState.currentUser?.userImageUrl != nil) {
            // Obtain URL from the FIRDatabase reference
            // postPhoto URL
            let obtainURL = NSURL(string: (AppState.currentUser?.userImageUrl)!)
            print ("Appstate \(AppState.currentUser?.userImageUrl)")
            print("Test first name \(AppState.currentUser?.firstName)")
            print ("This is test URL \(obtainURL)")
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
    

    
    
    //    func pollForPastEvents(withBlock: @escaping (Event) -> Void) {
    //        for _ in pastEvents {
    //            Constants.dbRef.observe(.value, with: { snapshot in
    //                if snapshot.exists() {
    //                    if let eventDict = snapshot.value as? [String: AnyObject] {
    //                        let retrievedEvent = Event(key: snapshot.key, eventDict: eventDict)
    //                        withBlock(retrievedEvent)
    //                    }
    //                } else {
    //                    print("Cannot access past event")
    //                }
    //            })
    //        }
    //    }
    
    
    
    // MARK: Get a user's pinnedEventIDs
    func getPinnedEventIds(withBlock: @escaping () -> Void){
        Constants.dbRef.child("users").child(uid).child("pinnedEvents").observe(.value, with: { snapshot in
            if snapshot.exists() {
                if let pinnedEventsIdsArray = snapshot.value as? [String] {
                    self.pinnedEventIds = pinnedEventsIdsArray
                    withBlock()
                    
                }
            } else {
                print("Cannot get this user's pinnedEventIds!")
                withBlock()
            }
        })
        
    }
    
  //MARK: Poll for Pinned Event Info and append to User's upcomingEvents Array
    func pollForPinnedEventInfo(withBlock: @escaping () -> Void) {
        print("polling for event info")
        let myGroup = DispatchGroup()
        
        for pinnedEventId in pinnedEventIds {
            myGroup.enter()

                Constants.dbRef.child("events").child(pinnedEventId).observe(.value, with: { snapshot in
                    if snapshot.exists() {
                        if let eventDict = snapshot.value as? [String: AnyObject] {
                            let retrievedEvent = Event(key: snapshot.key, eventDict: eventDict)
                            self.upcomingEvents.append(retrievedEvent)
                            self.pinnedEvents.append(retrievedEvent)
                        }
                    } else {
                        print("Cannot access a pinned event of the user")
                        
                        
                    }
                    myGroup.leave()

                })
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            withBlock()
        })
        



    }
   
    
    
// MARK: Get User's groupIDs
    func getGroupIds(withBlock: @escaping () -> Void){
        Constants.dbRef.child("users").child(uid).child("groupIds").observe(.value, with: { snapshot in
            if snapshot.exists() {
                if let groupIdsArray = snapshot.value as? [String] {
                    self.groupIds = groupIdsArray
                    withBlock()

                }
            } else {
                print("Cannot get this user's groupIds")
                withBlock()

            }
        })

    }
    
    
    // MARK: Polls for group info and initializes user's [Groups] array
    func pollForGroupInfo(withBlock: @escaping () -> Void) {
        let myGroup = DispatchGroup()

        for groupId in groupIds {
            myGroup.enter()
            Constants.dbRef.child("groups").child(groupId).observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    if let groupDict = snapshot.value as? [String: AnyObject] {
                        let retrievedGroup = Group(key: snapshot.key, groupDict: groupDict)
                        self.groups.append(retrievedGroup)
                    }
                } else {
                    print("Cannot get info for this groupID")
                }
                myGroup.leave()

            })
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            withBlock()
        })
    }
    
//    // MARK: Create the [Groups] array of the User
//    func getGroups(with: @escaping () -> Void){
//        self.getGroupIds(withBlock: {
//            self.pollForGroupInfo(withBlock: nil)
//            with()
//        })
//    }
    
    
    // MARK: Get events for each group and append to User's [Events] Array
    func getGroupEvents(withBlock: @escaping () -> Void){
        print("Getting group events")

        for group in self.groups{
            group.getEventInfoForFutureEvents(withBlock: {
                for event in group.events{
                    self.upcomingEvents.append(event)
                    //group.events.append(event)
                }
            })
        }
        withBlock()
    }
    
    // MARK: Sort Events upcomingEvents Array by date
    func sort(withBlock: () -> Void){
        
        upcomingEvents.sort{
            
            $0.date < $1.date
        }
        withBlock()
    }
    
    // MARK: Setup will initialize the AppState.currentUser's [Group]s array and [Event]s array
    func setup(withBlock: @escaping () -> Void){
        getGroupIds(withBlock: {
            self.pollForGroupInfo(withBlock: {
                self.getGroupEvents(withBlock: {
                    self.getPinnedEventIds(withBlock: {
                        self.pollForPinnedEventInfo(withBlock: {
                            print("Number of upcoming events is \(self.upcomingEvents.count)")
                            print("Number of groups you're in is \(self.groups.count)")

                            self.sort(withBlock: {
                                withBlock()        //Pass in the method to setup UI as withBlock for setup

                            })
                        })
                    })
                })
            })
        })
        
        
    }
    
    

   
    
    
}

