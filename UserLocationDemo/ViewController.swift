//
//  ViewController.swift
//  UserLocationDemo
//
//  Created by me on 03/11/2021.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController{

    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Properties
    private let databaseService = DatabaseService.shared
    private let coreLocationManager = CLLocationManager()
    private let regionInMeter: Double = 2000
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkLocationServices()
        
    }
    
    
    //MARK: Functions
    private func configureLocationService(){
        coreLocationManager.delegate = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    private func checkLocationServices(){
        
        if CLLocationManager.locationServicesEnabled(){
            //setup location manager
            configureLocationService()
            checkUserLocationPermission()
        }else{
            appearDialogToUser(title: "Location service disable", message: "Please enable location service")
        }
    }
    
    private func setCenterLocation(){
        
      if let location = coreLocationManager.location?.coordinate{
            
          let customLocation =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
              mapView.setRegion(customLocation, animated: true)
        }
    }
    
    func checkUserLocationPermission(){
        
        let authorizationStatus:CLAuthorizationStatus = coreLocationManager.authorizationStatus
        switch authorizationStatus{
        case .authorizedWhenInUse:
            //Do map stuff
            mapView.showsUserLocation = true
            setCenterLocation()
            coreLocationManager.startUpdatingLocation()
        case .denied:
            appearDialogToUser(title: "Permission denied", message: "Plese go to setting and allow location service")
        case .notDetermined:
            coreLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            //alert to user
            break
        case .authorizedAlways:
            break
         default:
            print("")
       
        }
   }
}

//MARK: Extenssions
extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            let currentPin = mapView.view(for: annotation) ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            currentPin.image = UIImage(systemName: "car.fill")
            
            return currentPin
        }
       
        return nil
    }
}

extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
        databaseService.setUserCurrentLocation(lat: lat, long: long)

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServices()
     }
    
}

