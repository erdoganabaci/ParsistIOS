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
            
            for doubleLat in self.doubleLatitute{
                let annotations = MKPointAnnotation()
                annotations.title = self.nameArray as? String
                annotations.coordinate = CLLocationCoordinate2D(latitude: doubleLat as! Double, longitude: self.doubleLongitute as! Double)
                self.mapView.addAnnotation(annotations)
            }
            
            
        }) { (error) in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert   )
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
      
    }
    func createLocation(){
        let x = ["1.0", "1.5", "2.0"]
        print("tamamı : \(x.map {Double($0)!})")
        let doubleArray = latituteArray.map{ Double($0)! }
        print(latituteArray)
        let doubleLatitute = latituteArray.map {Double($0)!}
        print(doubleLatitute)
        let doubleLongitute = longituteArray.map {Double($0)!}
        for location in doubleLatitute{
            let annotations = MKPointAnnotation()
            annotations.title = nameArray as? String
            annotations.coordinate = CLLocationCoordinate2D(latitude: location, longitude: doubleLongitute as! Double)
            mapView.addAnnotation(annotations)
        }
        
        
    }
    func newTestFirebase () {
        let ref = Database.database().reference().child("Locations")
        let query = ref.queryOrdered(byChild: "post").queryEqual(toValue: true)
        query.observeSingleEvent(of: .childAdded) { (snapshot) in
            for childSnapshot in snapshot.children{
                print(childSnapshot)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.chosenLatitute != nil && self.chosenLongitute != nil {
            
            for lat in latituteArray{
                 //location = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(self.longituteArray)?)
            }
            for (lat,long) in zip(self.chosenLatitute,self.chosenLongitute){
                location = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                self.mapView.addAnnotation(annotation)
                print("location : \(location)")
            }
            
           // let location = CLLocationCoordinate2D(latitude: Double(self.chosenLatitute)!, longitude: Double(self.chosenLongitute)!)
            
            manager.stopUpdatingLocation()
            
            
           // annotation.title = self.nameArray.last!
           // annotation.subtitle = self.typeArray.last!
            
            //print("seçilnmiş koridnat lat \(self.chosenLatitute)")
        }
        
    }
    
    @IBAction func parkListClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "frommapVCtoplacesVC", sender: nil)
    }
    
}

