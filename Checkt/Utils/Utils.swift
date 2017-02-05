//
//  Utils.swift
//  Checkt
//
//  Created by Eliot Han on 11/17/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let width = UIScreen.main.bounds.width
        // Small Size for the normal nav bar, big size for the "taller" nav bar in the left menu
        let smallSize = CGSize(width: width, height: 44)
        let bigSize = CGSize(width: width, height: 64)
        
        if AppState.hideStatusBar == true{
            return bigSize
        }else{
            return smallSize
            
            
        }
        
    }
}


extension UIImageView {
    func setRounded() {
        let radius = self.frame.width/2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
    }
}

extension Date{
    func isBetweenDates(beginDate: Date, endDate: Date) -> Bool
    {
        if self.compare(beginDate as Date) == .orderedAscending
        {
            return false
        }
        
        if self.compare(endDate as Date) == .orderedDescending
        {
            return false
        }
        
        return true
    }
    

}


extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 8000, 8000)
        setRegion(region, animated: true)
    }
}


       

       
