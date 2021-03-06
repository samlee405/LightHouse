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

class NewRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var newRoomTextField: UITextField!
    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NewRoomViewControllerDelegate?
    var availableLights: [String] = []
    var lightsToAdd: [String] = []
    var roomBeacon: CLBeacon?
    
    var estimoteHelper: EstimoteHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newRoomTextField.attributedPlaceholder =
            NSAttributedString(string: "Room Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        tableView.delegate = self
        tableView.dataSource = self

        estimoteHelper = EstimoteHelper()
        estimoteHelper.getNearestBeacon { (estimote) in
            print(estimote)
        }
        
        searchForAvailableLights()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        var frame: CGRect = self.tableView.frame
        frame.size.height = self.tableView.contentSize.height
        self.tableView.frame = frame
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    
    }
    
    @IBAction func saveBeacon(_ sender: AnyObject) {
        let room = Room(name: newRoomTextField.text!, roomBeacon: roomBeacon)

        for light in lightsToAdd {
            room.roomLights.append(light)
        }
        
        HueHelper.sharedInstance.createGroup(lights: lightsToAdd, roomName: newRoomTextField.text!)
        
        delegate?.addNewRoom(room: room)
        performSegue(withIdentifier: "unwindToRoomTableViewController", sender: self)
    }
    
    // WORKS
    func searchForAvailableLights() {
        HueHelper.sharedInstance.getLights { (result) in
            print(result)
            self.availableLights = result
            self.tableView.reloadData()
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
        cell.lightTextLabel.text = String(describing: availableLights[indexPath.row])
        
        return cell
    }
    
    func beaconsFound(beacons: [CLBeacon]) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon
            print(closestBeacon)
            
            // Assign the closest beacon to room parameters.
            roomBeacon = closestBeacon
            beaconLabel.text = String(describing: closestBeacon)
        }
    }
}

