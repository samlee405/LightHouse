//
//  ViewController.swift
//  LightHouse
//
//  Created by Sam Lee on 11/17/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var beaconInfoTextLabel: UILabel?
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(), identifier: "f2f")
    
//    var colors: Dictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
//            self.view.BackgroundColor = self.colors[closestBeacon.minor]
            beaconInfoTextLabel.text = String(description: closestBeacon)
        }
    }

}

