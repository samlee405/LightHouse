//
//  NewRoomViewController.swift
//  LightHouse
//
//  Created by Sam Lee on 11/17/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit
import CoreLocation

protocol NewRoomViewControllerDelegate {
    func addNewRoom(room: Room)
}

class NewRoomViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newRoomTextField: UITextField!
    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NewRoomViewControllerDelegate?
    var roomBeacon: String?
    var availableLights: [[Any]] = []
    var lightsToAdd: [String] = []
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "test")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        
        searchForAvailableLights()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        var frame: CGRect = self.tableView.frame
        frame.size.height = self.tableView.contentSize.height
        self.tableView.frame = frame
    }

    @IBAction func saveBeacon(_ sender: AnyObject) {
        let room = Room(name: newRoomTextField.text!)
        if let beacon = roomBeacon {
            room.roomBeacon = beacon
        }
        for light in lightsToAdd {
            room.roomLights.append(Light(id: light))
        }
        
        delegate?.addNewRoom(room: room)
        performSegue(withIdentifier: "unwindToRoomTableViewController", sender: self)
    }
    
    func searchForAvailableLights() {
        let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
        if cache?.lights != nil {
            for (key, value) in (cache?.lights)! {
                availableLights.append([key, value])
                self.tableView.reloadData()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            roomBeacon = String(describing: closestBeacon)
        }
    }
    
    func addLight(light: String) {
        lightsToAdd.append(light)
    }
    
    // MARK: - Tableview protocol functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableLights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath) as! NewRoomTableViewCell
        cell.parentViewController = self
        cell.lightTextLabel.text = String(describing: availableLights[indexPath.row][1])
        
        return cell
    }
}

