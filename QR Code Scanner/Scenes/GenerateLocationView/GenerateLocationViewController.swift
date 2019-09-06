//
//  GenerateLocationViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 8/13/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GenerateLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var btnGenerate: UIButton!
    
    let locationManager = CLLocationManager()
    
    @IBAction func btnGenerate(_ sender: Any) {
        self.performSegue(withIdentifier: "segueLocationToQRcode", sender: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupButtonGenerate()
        // Do any additional setup after loading the view.
    }
    
    func setupButtonGenerate(){
        btnGenerate.backgroundColor = ScanManager.shared.hexStringToUIColor(hex: "#C7B8F5")
        btnGenerate.layer.cornerRadius = 14
        btnGenerate.layer.masksToBounds = true
        btnGenerate.setTitleColor(ScanManager.shared.hexStringToUIColor(hex: "#ffffff"), for: .normal)
    }
    
    func setupLocationManager(){
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Your Location"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
