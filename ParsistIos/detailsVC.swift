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
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var requewstCLlocation = CLLocation()
    override func viewDidLoad(){
        super.viewDidLoad()
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
       
    }
    

    

}
