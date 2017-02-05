//
//  AppDelegate.swift
//  Checkt
//
//  Created by Eliot Han on 10/27/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import SwiftMessages
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        locationManager.delegate = self
        if (FIRAuth.auth()?.currentUser) != nil {
           
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Checktboard", bundle: nil)
                let checktboardVC = mainView.instantiateViewController(withIdentifier: "ChecktboardVC") as! ChecktBoardVC
                let navigationController = UINavigationController(rootViewController: checktboardVC)
                self.window!.rootViewController = navigationController
                
                
                locationManager.delegate = self
                locationManager.requestAlwaysAuthorization()
                
                
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                    // Enable or disable features based on authorization.
                }
                application.registerForRemoteNotifications()
                center.removeAllPendingNotificationRequests()
                
            
           
        } else{
            //move to main.storyboard
        }
        

        
        
        return true
    }
    
    func handleEvent(forRegion region: CLRegion!) {
        // Show an alert if application is active
        if UIApplication.shared.applicationState == .active {
            guard let eventName = checkIn(fromRegionIdentifier: region.identifier) else { return }
            
            //Swift Msgs pod
            let view = MessageView.viewFromNib(layout: .CardView)
            view.configureDropShadow()
            let iconText = "✔︎"
            view.configureTheme(backgroundColor: Constants.greenThemeCol, foregroundColor: UIColor.white)
            view.button?.isHidden = true
            view.configureContent(title: "", body: "You have been checked in for \(eventName)", iconText:iconText)
            view.bodyLabel?.font = UIFont.boldSystemFont(ofSize: 15)
            var config = SwiftMessages.Config()
            config.presentationStyle = .top
            SwiftMessages.show(config: config, view: view)

            
        } else {
            // Otherwise present a local notification
            let notification = UILocalNotification()
            //let notification = UNNotificationRequest()
            guard let eventName = checkIn(fromRegionIdentifier: region.identifier) else { return }
         
            notification.alertBody = "You have been checked in for \(eventName)"
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    func checkIn(fromRegionIdentifier identifier: String) -> String?{
        for event in (AppState.currentUser?.upcomingEvents)!{
            if event.region?.identifier == identifier{
                let date = Date()
                if date.isBetweenDates(beginDate: stringToDate(string: event.startTime), endDate: stringToDate(string: event.endTime)){
                    return event.name     //Will only check in to single event if there are two events starting at the same interval and location
                }
            }
        }
        return nil
    }
    


    
    //converts string to date object
    func stringToDate(string: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date = dateFormatter.date(from: string)
        return date!
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func logout(){
        try! FIRAuth.auth()!.signOut()
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Main", bundle: nil)
        let firstSigninVC = mainView.instantiateViewController(withIdentifier: "FirstSigninVC") as! FirstSigninVC
        let navigationController = UINavigationController(rootViewController: firstSigninVC)
        
        
        UIView.transition(with: self.window!, duration: 0.25, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navigationController;
            //self.view.window!.rootViewController = navigationController
            navigationController.popToRootViewController(animated: false)
        
            
        }, completion: nil)
        
    }

}
extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(forRegion: region)
        }
    }
}

