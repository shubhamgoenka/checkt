//
//  Event.swift
//  Checkt
//
//  Created by Shubham Goenka on 12/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

enum Type {
    case publicEvent
    case privateEvent
}


class Event {
    
    var eventId: String = ""
    var code: String = ""
    var name: String = ""
    var location: [String: AnyObject] = [:]
    var date: String = ""
    var startTime: String = ""
    var endTime: String = ""
    var timeInterval: Int = 0
    var description: String = ""
    var hostGroup: String = ""
    var usersPinned: [String] = []
    var usersAttended: [String] = []
    
    var eventType:EventType?
    
    var region: CLCircularRegion?
    
    //If an event is public, passcode will not contain a value
    var passcode: String?
   
    
    init(key: String, eventDict: [String: AnyObject]) {
        eventId = key
        if let eventCode = eventDict["code"] as? String {
            code = eventCode
        }
        if let eventName = eventDict["eventName"] as? String {
            name = eventName
        }
        if let loc = eventDict["region"] as? [String: AnyObject] {
            location = loc
            let center = CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude: location["longitude"] as! CLLocationDegrees)
           
            region = CLCircularRegion(center: (center as? CLLocationCoordinate2D)!, radius: location["radius"] as! CLLocationDistance, identifier: name)
            eventType = location["eventType"] as! EventType?
        }
        if let eventDate = eventDict["date"] as? String {
            date = eventDate
        }
        if let start = eventDict["startTime"] as? String {
            startTime = start
        }
        if let end = eventDict["endTime"] as? String {
            endTime = end
        }
        if let interval = eventDict["timeInterval"] as? Int {
            timeInterval = interval
        }
        if let desc = eventDict["description"] as? String {
            description = desc
        }
        if let host = eventDict["hostGroup"] as? String {
            hostGroup = host
        }
        if let pinned = eventDict["usersPinned"] as? [String] {
            usersPinned = pinned
        }
        if let attended = eventDict["usersAttended"] as? [String] {
            usersAttended = attended
        }
    }
    
    
    func getHostGroup(withBlock: @escaping (Group) -> Void) {
        Constants.dbRef.observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                if let groupDict = snapshot.value as? [String: AnyObject] {
                    let retreivedGroup = Group(key: snapshot.key, groupDict: groupDict)
                    withBlock(retreivedGroup)
                }
            } else {
                print("Cannot access host group")
            }
        })
    }
    
    func pollForUsersPinned(withBlock: @escaping (User) -> Void) {
        for _ in usersPinned {
            Constants.dbRef.observe(.value, with: { snapshot in
                if snapshot.exists() {
                    if let userDict = snapshot.value as? [String: AnyObject] {
                        let retrievedUser = User(key: snapshot.key, userDict: userDict)
                        withBlock(retrievedUser)
                    }
                } else {
                    print("Cannot access user that pinned the event")
                }
            })
        }
    }
    
    func pollForUsersAttended(withBlock: @escaping (User) -> Void) {
        for _ in usersAttended {
            Constants.dbRef.observe(.value, with: { snapshot in
                if snapshot.exists() {
                    if let userDict = snapshot.value as? [String: AnyObject] {
                        let retrievedUser = User(key: snapshot.key, userDict: userDict)
                        withBlock(retrievedUser)
                    }
                } else {
                    print("Cannot access user that attended the event")
                }
            })
        }
    }
    
}

