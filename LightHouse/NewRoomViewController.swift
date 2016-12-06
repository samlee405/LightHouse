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
        room.roomLights = [Light(room: "Light 1"), Light(room: "Light 2"), Light(room: "Light 3")] // To be updated
        
        delegate?.addNewRoom(room: room)
        performSegue(withIdentifier: "unwindToRoomTableViewController", sender: self)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            roomBeacon = String(describing: closestBeacon)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // Change later after bridging Hue SDK
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath)
        cell.textLabel?.text = "Light \(indexPath.row)" // Update after implementing Hue SDK
        
        return cell
    }
}

