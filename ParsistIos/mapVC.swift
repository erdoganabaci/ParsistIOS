//
//  ViewController.swift
//  ParsistIos
//
//  Created by Erdo on 21.01.2019.
//  Copyright © 2019 Erdo. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
class mapVC: UIViewController,MKMapViewDelegate , CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var requestCLlocation = CLLocation()
    var chosenLatitute = ""
    var chosenLongitute = ""
    
    var nameArray = [String]()
    var typeArray = [String]()
    var atmosphereArray = [String]()
    var latituteArray = [String]()
    var longituteArray = [String]()
    var imageArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        //manager.startUpdatingLocation() //veriler yokken güncellemek mantıksız veriler olduğunda güncelle.
        //locasyon update durdurmayı unutma locationmanager çağrılınca iptal etsin güncellemeyi.
        getDataFromFirebase()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.chosenLatitute != "" && self.chosenLongitute != "" {
            let location = CLLocationCoordinate2D(latitude: Double(self.chosenLatitute)!, longitude: Double(self.chosenLongitute)!)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: true)
            manager.stopUpdatingLocation()
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.nameArray.last!
            annotation.subtitle = self.typeArray.last!
            self.mapView.addAnnotation(annotation)
        
        }
       
    }
    func getDataFromFirebase(){
        let databaseReference = Database.database().reference()
        databaseReference.child("Locations").observe(DataEventType.childAdded) { (snapshot) in
            let values = snapshot.value as! NSDictionary
            // print("Değerler : \(values)")
            
            //let post = values["post"] as! NSDictionary
            let locationID = values.allKeys //all keys taken
            //print("Tüm locasyon idleri : \(locationID)")
            for id in locationID{
                let singleLocation = values[id] as! NSDictionary
                print(singleLocation["parkname"] as! String) //her birinin değerleri getirildi.
            }
            
        }
    }
    
    
    
    
    @IBAction func parkListClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "frommapVCtoplacesVC", sender: nil)
    }
    
}

