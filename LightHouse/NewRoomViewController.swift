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

class NewRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EstimoteHelperDelegate {
    
    @IBOutlet weak var newRoomTextField: UITextField!
    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NewRoomViewControllerDelegate?
    var roomBeacon: CLBeacon?
    
    var estimoteHelper: EstimoteHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        estimoteHelper = EstimoteHelper()
        estimoteHelper.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        var frame: CGRect = self.tableView.frame
        frame.size.height = self.tableView.contentSize.height
        self.tableView.frame = frame
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        estimoteHelper.endRanging()
    }
    
    @IBAction func saveBeacon(_ sender: AnyObject) {
        let room = Room(name: newRoomTextField.text!, roomBeacon: estimoteHelper.getNearestEstimote())
        
        room.roomLights = [Light(room: "Light 1"), Light(room: "Light 2"), Light(room: "Light 3")] // To be updated
        
        delegate?.addNewRoom(room: room)
        performSegue(withIdentifier: "unwindToRoomTableViewController", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // Change later after bridging Hue SDK
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lightCell", for: indexPath)
        cell.textLabel?.text = "Light \(indexPath.row)" // Update after implementing Hue SDK
        
        return cell
    }
    
    func beaconsFound(beacons: [CLBeacon]) {
        beaconLabel.text = estimoteHelper.getNearestEstimote().debugDescription
    }
}

