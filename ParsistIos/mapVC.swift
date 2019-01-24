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
    var location = CLLocationCoordinate2D()
    var chosenLatitute = [String]()
    var chosenLongitute = [String]()
    
    var nameArray = [String]()
    var typeArray = [String]()
    var situationArray = [String]()
    var latituteArray = [String]()
    var longituteArray = [String]()
    var imageArray = [String]()
    var doubleLatitute = [Double]()
    var doubleLongitute = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        getDataFromFirebase()
        //newTestFirebase()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
        //manager.startUpdatingLocation() //veriler yokken güncellemek mantıksız veriler olduğunda güncelle.
        //locasyon update durdurmayı unutma locationmanager çağrılınca iptal etsin güncellemeyi.
        createLocation()
      
       
    }
  
    func getDataFromFirebase(){
        //güvenli kod için fonksiyon her açıldığında içi boş array gelip doldurcak.
        self.nameArray.removeAll(keepingCapacity: false)
        self.typeArray.removeAll(keepingCapacity: false)
        self.situationArray.removeAll(keepingCapacity: false)
        self.latituteArray.removeAll(keepingCapacity: false)
        self.longituteArray.removeAll(keepingCapacity: false)
        self.imageArray.removeAll(keepingCapacity: false)
        
        let databaseReference = Database.database().reference()
        databaseReference.child("Locations").observe(DataEventType.childAdded, with: { (snapshot) in
            let values = snapshot.value as! NSDictionary
            // print("Değerler : \(values)")
            
            //let post = values["post"] as! NSDictionary
            let locationID = values.allKeys //all keys taken
            //print("Tüm locasyon idleri : \(locationID)")
            for id in locationID{
                let singleLocation = values[id] as! NSDictionary
                //print(singleLocation["parkname"] as! String) //her birinin değerleri getirildi.
                // print(singleLocation["downloadurl"] as! String )
                self.nameArray.append(singleLocation["parkname"] as! String)
                self.typeArray.append(singleLocation["parkdetail"] as! String)
                self.situationArray.append(singleLocation["situation"] as! String)
                self.latituteArray.append(singleLocation["latitute"] as! String)
                self.longituteArray.append(singleLocation["longitute"] as! String)
                self.imageArray.append(singleLocation["downloadurl"] as! String)
                self.doubleLatitute = self.latituteArray.map{ Double($0)! }
                self.doubleLongitute = self.longituteArray.map{ Double($0)! }
                //print(self.doubleLatitute)
                ////////////////
            /*    for lat in self.latituteArray{
                    self.chosenLatitute.append(lat)
                }
                //print("choosen lat array : \(self.chosenLatitute)")
                for long in self.longituteArray{
                    self.chosenLongitute.append(long)
                }
          */
               
            }
          
            //print("Lat datası \(self.latituteArray)")
         
            for id in locationID{
                let singleLocation = values[id] as! NSDictionary
                let annotations = MKPointAnnotation()
                annotations.title = singleLocation["parkname"] as! String
                var poiCoodinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
                
                poiCoodinates.latitude = CDouble(singleLocation["latitute"] as! String)!
                poiCoodinates.longitude = CDouble(singleLocation["longitute"] as! String )!
                //print("name \(name)")
               // annotations.coordinate = CLLocationCoordinate2D(latitude: doubleLat as! Double, longitude: self.doubleLongitute as! Double)
                annotations.coordinate = CLLocationCoordinate2D(latitude:poiCoodinates.latitude , longitude:poiCoodinates.longitude)
                self.mapView.addAnnotation(annotations)
            }
            
            /*
            for name in self.nameArray{
                let annotations = MKPointAnnotation()
                annotations.title = name
                print("name \(name)")
                // annotations.coordinate = CLLocationCoordinate2D(latitude: doubleLat as! Double, longitude: self.doubleLongitute as! Double)
                annotations.coordinate = CLLocationCoordinate2D(latitude:CDouble(exactly: self.latituteArray), longitude:self.doubleLongitute as! Double)
                self.mapView.addAnnotation(annotations)
            }
            
            
         */
            
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert   )
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
      
    }
    func createLocation(){
     
        
    }
 
    
    func allMapAnnotation(){
        for doubleLat in self.doubleLatitute{
            
            for doubleLong in self.doubleLongitute {
                
                let annotations = MKPointAnnotation()
                
                annotations.coordinate = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong)
                
                //annotations.title = nameArray as! String  //bunu ekleyince çalışmıyor loopta yok diye yada loopda dönerken hata veriyor.
                
                self.mapView.addAnnotation(annotations)
                
            }
    }
}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locasyon update edildiğinde  kullanıcıya focus atması için
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        
        
            
            manager.stopUpdatingLocation()
            
            
        
    
    }
    
    @IBAction func parkListClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "frommapVCtoplacesVC", sender: nil)
    }
    
}

