//
//  Group.swift
//  Checkt
//
//  Created by Shubham Goenka on 12/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import Firebase


enum Privacy {
    case protected
    case openToPublic
}


class Group {
    
    var groupId: String = ""
//    var name: String = ""
    var passcode: String = ""
    var groupImageUrl: String = ""
    var members: [String] = []
    var admins: [String] = []
    var futureEvents: [String] = []
    var pastEvents: [String] = []
    var numMembers: Int = 0
    var description: String = ""
    var events: [Event] = []
    
    var groupImage: UIImage?
    
    init(key: String, groupDict: [String: AnyObject]) {
        groupId = key
//        if let groupName = groupDict["name"] as? String {
//            name = groupName
//        }
        if let pass = groupDict["passcode"] as? String {
            passcode = pass
        }
        if let groupImg = groupDict["groupImageurl"] as? String {
            groupImageUrl = groupImg
        }
        if let desc = groupDict["description"] as? String {
            description = desc
        }
        if let mems = groupDict["members"] as? [String] {
            members = mems
        }
        if let administrators = groupDict["admins"] as? [String] {
            admins = administrators
        }
        if let future = groupDict["futureEvents"] as? [String] {
            futureEvents = future
        }
        if let past = groupDict["pastEvents"] as? [String] {
            pastEvents = past
        }
        numMembers = members.count
    }
    
    
    func getGroupImage(withBlock: @escaping (UIImage) -> Void) {
        print(groupImageUrl)
        if (groupImageUrl != "") {
            let obtainURL = NSURL(string: groupImageUrl)
            let picChosen = NSData(contentsOf: obtainURL as! URL)
            if picChosen != nil {
                let image = UIImage(data: picChosen as! Data)
                withBlock(image!)
            } else {
                let image = UIImage(named: "Google Groups-500")
                withBlock(image!)
            }
        }
    }
    
    func pollForMembers(withBlock: @escaping (User) -> Void) {
        for _ in members {
            Constants.dbRef.observe(.value, with: { snapshot in
                if snapshot.exists() {
                    if let userDict = snapshot.value as? [String: AnyObject] {
                        let retrievedUser = User(key: snapshot.key, userDict: userDict)
                        withBlock(retrievedUser)
                    }
                } else {
                    print("Cannot access member")
                }
            })
        }
    }
    
    func pollForAdmins(withBlock: @escaping (User) -> Void) {
        for _ in admins {
            Constants.dbRef.observe(.value, with: { snapshot in
                if snapshot.exists() {
                    if let userDict = snapshot.value as? [String: AnyObject] {
                        let retrievedUser = User(key: snapshot.key, userDict: userDict)
                        withBlock(retrievedUser)
                    }
                } else {
                    print("Cannot access admin")
                }
            })
        }
    }
    
    //Get info for future events and return [Events] array
    func getEventInfoForFutureEvents(withBlock: @escaping () -> Void){
        let myGroup = DispatchGroup()

        for eventID in futureEvents {
            myGroup.enter()

            Constants.dbRef.child("events").child(eventID).observe(.value, with: { snapshot in
                if snapshot.exists() {
                    if let eventDict = snapshot.value as? [String: AnyObject] {
                        let retrievedEvent = Event(key: snapshot.key, eventDict: eventDict)
                        self.events.append(retrievedEvent)
                    }
                } else {
                    print("Cannot access future event")
                }
                myGroup.leave()

            })
            
        }
        myGroup.notify(queue: DispatchQueue.main, execute: {
            withBlock()
        })
        
    }
    
    func pollForPastEvents(withBlock: @escaping (Event) -> Void) {
        for _ in pastEvents {
            Constants.dbRef.observe(.value, with: { snapshot in
                if snapshot.exists() {
                    if let eventDict = snapshot.value as? [String: AnyObject] {
                        let retrievedEvent = Event(key: snapshot.key, eventDict: eventDict)
                        withBlock(retrievedEvent)
                    }
                } else {
                    print("Cannot access past event")
                }
            })
        }
    }
    
}

