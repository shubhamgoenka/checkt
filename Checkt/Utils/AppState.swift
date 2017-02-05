//
//  AppState.swift
//  Checkt
//
//  Created by Eliot Han on 11/19/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase


struct AppState{
    static var sharedInstance = AppState()
    static var hideStatusBar: Bool = false
    static var currentUser: User?
    var signedIn = false
    static var upcomingEvents: [Event] = []
    static var hasFiltered:Bool = false
    static var filteredGroup: Group?
    
}
