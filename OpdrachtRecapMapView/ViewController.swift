//
//  ViewController.swift
//  OpdrachtRecapMapView
//
//  Created by mobapp03 on 15/01/2020.
//  Copyright © 2020 mobapp03. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager.init()
    var data:DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        data = DataSource.init()
        mapView.addAnnotations(data!.items)
    }

    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1: mapView.mapType = .satellite
        default: print("kan niet")
        }
    }
}

extension ViewController:CLLocationManagerDelegate{
      
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse: mapView.showsUserLocation = true
        case .authorizedAlways: mapView.showsUserLocation = true
        case .notDetermined: print("Choose eh peken")
        default: showNoPermissionAlert()
        }
    }
    
    func showNoPermissionAlert(){
        let alert = UIAlertController.init(title: "Caution", message: "Please turn on your location to enable the use of all features of the app!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
extension ViewController:MKMapViewDelegate{
    
    @IBAction func longPressExec(_ sender: UILongPressGestureRecognizer) {
        
        let pressedPoint = sender.location(in: mapView)
        let coordFromPoint = mapView.convert(pressedPoint, toCoordinateFrom: mapView)
        
        let alert = UIAlertController.init(title: "Place your pin!", message: "Please give a name to your location", preferredStyle: .alert)
        alert.addTextField{(textField) in textField.placeholder = "Type in your location name"}
        alert.addTextField{(textField) in textField.placeholder = "Type in your category pin"}
        let cancelPlacement = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        let confirmPlacement = UIAlertAction.init(title: "Confirm", style: .default, handler:{(action:UIAlertAction)->Void in
            let namePinInput = alert.textFields![0].text!
            let categorieInput = alert.textFields![1].text!
            let poi = PointOfInterest.init(coordinate: coordFromPoint, title: namePinInput)
            
            poi.category = categorieInput
            self.data?.items.append(poi)
            self.mapView.addAnnotation(poi)
        })
        
        alert.addAction(cancelPlacement)
        alert.addAction(confirmPlacement)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //is de annotatie een point of interest dan ga ik het omzetten naar de klasse point of interest
        //enkel iets uitvoeren als het lukt
        if let poi = annotation as? PointOfInterest{
            
            //nagaan of eral een pin was tekenend
            if let customView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin"){
                //pin bestaat al, opvullen met poi
                customView.annotation = poi
                return customView
            }else{
                //pin bestond niet, pin opbouwen
                let customView = MKMarkerAnnotationView.init(annotation: poi, reuseIdentifier: "pin")
                
                customView.canShowCallout = true
                
                switch  poi.category{
                case "yellow":
                    customView.markerTintColor = UIColor.systemYellow
                case "blue":
                    customView.markerTintColor = UIColor.systemTeal
                case "green":
                    customView.markerTintColor = UIColor.systemGreen
                case "red":
                    customView.markerTintColor = UIColor.systemRed
                case "purple":
                    customView.markerTintColor = UIColor.systemPurple
                default:
                    customView.markerTintColor = UIColor.black
                }
                
                return customView
                
            }
        }
        return nil
    }
}

