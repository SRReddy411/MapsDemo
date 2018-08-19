//
//  ViewController.swift
//  GoogleMapsDemo
//
//  Created by Admin on 19/08/2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapsView: UIView!
    var googleMapsView:GMSMapView!
    var locationManager:CLLocationManager!
    let marker = GMSMarker()
    var lat :CGFloat!
    var long:CGFloat!
    var locValue:CLLocationCoordinate2D!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.googleMapsView = GMSMapView(frame: mapsView.bounds)
        self.googleMapsView.delegate = self
        self.mapsView.addSubview(self.googleMapsView)
    
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       locValue = (manager.location?.coordinate)!
//       lat = manager.location?.coordinate.latitude
//       long = manager.location?.coordinate.longitude
        googleMapsView.delegate = self
        let camera = GMSCameraPosition.camera(withLatitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!, zoom: 10.0)
        googleMapsView.camera = camera
        print("Current Locations = \(locValue.latitude) \(locValue.longitude)")
        //showMarker(position: camera.target)
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                let latitude: CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
                let longitude: CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
                let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        return
                    }else if let country = placemarks?.first?.country,
                        let city = placemarks?.first?.locality {
                        print("country and city ,country code",country,city,placemarks?.first?.isoCountryCode)
                        
                        self.marker.position = camera.target
                        self.marker.title = city
                        self.marker.snippet = country
                        self.marker.isDraggable = true
                        self.marker.map = self.googleMapsView
                       // self.cityNameStr = city
                    }
                    else {
                    }
                })
                break
                
            case .notDetermined:
                print("Not determined.")
             
                break
                
            case .restricted:
                print("Restricted.")
                
                break
                
            case .denied:
                print("Denied.")
            }
        }
    //locationManager.stopUpdatingLocation()
    
}
   
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("error featching location",error)
    }
    
    //MARK:- GOOGLE MAPS DELEGATE METHODS
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        
        print("didEndDragging  lat,long    ",marker.position.latitude,marker.position.longitude)
        
        let latitude: CLLocationDegrees = marker.position.latitude
        let longitude: CLLocationDegrees = marker.position.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                return
            }else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                print("country and city ,country code",country,city,placemarks?.first?.isoCountryCode)
                
                //self.marker.position = camera.target
                self.marker.title = city
                self.marker.snippet = country
                self.marker.isDraggable = true
                self.marker.map = self.googleMapsView
                // self.cityNameStr = city
            }
        })
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        self.marker.position = coordinate
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print(position.target.latitude,position.target.longitude)
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    

    @IBAction func navigateBtnAction(_ sender: Any) {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {
            let urlString = "http://maps.google.com/?daddr=\(locValue.latitude),\(locValue.longitude)&directionsmode=driving"
            
            // use bellow line for specific source location
            
            //let urlString = "http://maps.google.com/?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&directionsmode=driving"
            
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
        else
        {
            //let urlString = "http://maps.apple.com/maps?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&dirflg=d"
            let urlString = "http://maps.apple.com/maps?daddr=\(locValue.latitude),\(locValue.longitude)&dirflg=d"
            
            UIApplication.shared.openURL(URL(string: urlString)!)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

