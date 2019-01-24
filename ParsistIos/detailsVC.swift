//
//  detailsVC.swift
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
class detailsVC: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {
    var selectedPlace = ""
    var chosenLatitute = ""
    var chosenLongitute = ""
    var anotationname = ""
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
     var nameArray = [String]()
     var typeArray = [String]()
     var atmosphereArray = [String]()
     var latituteArray = [String]()
     var longituteArray = [String]()
     var imageArray = [String]()
    
    var manager = CLLocationManager()
    var requestCLlocation = CLLocation()
    override func viewDidLoad(){
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        findPlaceFromFirebase()
    }
    
    func findPlaceFromFirebase()  {
        self.nameArray.removeAll(keepingCapacity: false)
        self.typeArray.removeAll(keepingCapacity: false)
        self.atmosphereArray.removeAll(keepingCapacity: false)
        self.latituteArray.removeAll(keepingCapacity: false)
        self.longituteArray.removeAll(keepingCapacity: false)
        self.imageArray.removeAll(keepingCapacity: false)
        print("Fonksiyon çalıştırıldı")
        let databaseReference = Database.database().reference().child("Locations").child("post")
        databaseReference.queryOrdered(byChild: "parkname").queryEqual(toValue: self.selectedPlace).observe(DataEventType.childAdded, with: { (snapshot) in
            if snapshot.exists(){
                let values = snapshot.value! as! NSDictionary
                self.nameArray.append(values["parkname"] as! String)
                self.typeArray.append(values["parkdetail"] as! String)
                self.atmosphereArray.append(values["situation"] as! String)
                self.latituteArray.append(values["latitute"] as! String)
                self.longituteArray.append(values["longitute"] as! String)
                self.imageArray.append(values["downloadurl"] as! String)
                
                let annotations = MKPointAnnotation()
                annotations.title = self.selectedPlace as! String
                var poiCoodinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
                
                poiCoodinates.latitude = CDouble(values["latitute"] as! String)!
                poiCoodinates.longitude = CDouble(values["longitute"] as! String )!
                //print("name \(name)")
                // annotations.coordinate = CLLocationCoordinate2D(latitude: doubleLat as! Double, longitude: self.doubleLongitute as! Double)
                annotations.coordinate = CLLocationCoordinate2D(latitude:poiCoodinates.latitude , longitude:poiCoodinates.longitude)
                self.mapView.addAnnotation(annotations)
                print(self.latituteArray)
                
            }else{
                let alert = UIAlertController(title: "Error", message: "Database Connection Failed", preferredStyle: UIAlertController.Style.alert   )
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        }) { (error) in
        
             let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert   )
             let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
             alert.addAction(okButton)
             self.present(alert, animated: true, completion: nil)
            
        }
        
       
        
       
    }
    

}
