//
//  MapVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/28/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation



protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapVC: UIViewController {
    var addButton: UIButton = UIButton()
    var searchBar: UISearchBar!
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()
    
    var mapView: MKMapView!
    var locationStringPassed: String?
    var locationPassed: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let story = UIStoryboard(name: "Checktboard", bundle: nil)
        let searchLocationVC = story.instantiateViewController(withIdentifier: "SearchLocationVC") as! SearchLocationVC

        resultSearchController = UISearchController(searchResultsController: searchLocationVC)
        resultSearchController.searchResultsUpdater = searchLocationVC
        searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchBar.delegate = self
        
        
        mapView = MKMapView(frame: CGRect(x: 0, y: view.frame.minY, width: view.frame.width, height: view.frame.height))
        mapView.zoomToUserLocation()
        mapView.delegate = self
        view.addSubview(mapView)
    
        searchLocationVC.mapView = mapView
        searchLocationVC.handleMapSearchDelegate = self
        
        
    }
    func addLocation(){
        let annotation = mapView.annotations[0]
        self.locationStringPassed = ((annotation.title! ?? "") + ", " +  (annotation.subtitle! ?? ""))
        self.locationPassed = Location(coordinate: annotation.coordinate, radius: 100, identifier: "", note: "", eventType: .onEntry)
        performSegue(withIdentifier: "unwindToCreateEventVC", sender: self)
    }
    
}

extension MapVC : CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension MapVC: HandleMapSearch {
    
    func addRadiusOverlay(location: Location) {
        mapView?.add(MKCircle(center: location.coordinate, radius: location.radius))
    }
    
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
    
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
    
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        
        
        mapView.setRegion(region, animated: true)
        addRadiusOverlay(location: Location(coordinate: placemark.coordinate, radius: 100.0, identifier: "", note: "", eventType: .onEntry))
        
        
        
        //For right bar button
        addButton.isHidden = false
        addButton.setTitle("Add", for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.titleLabel?.minimumScaleFactor = 0.6
        addButton.addTarget(self, action: #selector(self.addLocation), for: .touchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = addButton
        self.navigationItem.rightBarButtonItem = rightButton

       
    }
    
}

extension MapVC : MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
//        
//        guard !(annotation is MKUserLocation) else { return nil }
//        
//        let reuseId = "pin"
//        guard let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView else { return nil }
//        
//        pinView.pinTintColor = UIColor.green
//        
////        pinView.canShowCallout = true
////        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
////        button.setBackgroundImage(UIImage(named: "car"), forState: .normal)
////        button.addTarget(self, action: #selector(ViewController.getDirections), forControlEvents: .TouchUpInside)
////        pinView.leftCalloutAccessoryView = button
//        
//        return pinView
//    }
//    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
}
extension MapVC: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if mapView.annotations.count == 0{
            addButton.isHidden = true
            searchBar.sizeToFit()

        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if mapView.annotations.count == 0{
            addButton.isHidden = true
            searchBar.sizeToFit()

        } else{
            
        }
       
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            mapView.removeAnnotations(mapView.annotations)
            addButton.isHidden = true
            searchBar.sizeToFit()
        }
    }
    
    
}


