//
//  RoomTableViewController.swift
//  LightHouse
//
//  Created by Sam Lee on 11/29/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

class RoomTableViewController: UITableViewController, NewRoomViewControllerDelegate, ESTBeaconManagerDelegate {
    
    var roomArray = [Room]()
    
    var closestBeacon: CLBeacon? {
        didSet {
            //This won't work with multiple devices right now. Leaving a room will turn off the lights even if there are other people still in the room. Entering rooms that already have lights on shouldn't be a problem though.
            //Turn off the lights from the room we just left
            HueHelper.sharedInstance.turnOffLightsForGroup(group: (oldValue?.minor.intValue)!)
            
            // turn on lights for the room we're walking into

            HueHelper.sharedInstance.turnOnLights(group: (closestBeacon?.minor.intValue)!)
        }
    }
    
    let beaconManager = (UIApplication.shared.delegate as! AppDelegate).beaconManager
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "test")

    override func viewDidLoad() {
        super.viewDidLoad()
        beaconManager.delegate = self
        
        beaconManager.startRangingBeacons(in: region)
    }
    
    func addNewRoom(room: Room) {
        roomArray.append(room)
        tableView.reloadData()
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        
        if (knownBeacons.count > 0) {
            closestBeacon = knownBeacons[0] as CLBeacon
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as! RoomTableViewCell
        let cellRoom = self.roomArray[indexPath.row]
       
        cell.roomTitleLabel.text = cellRoom.roomTitle
        cell.currentBeacon = cellRoom.roomBeacon.proximityUUID.uuidString
        cell.lightsArray = cellRoom.roomLights

        return cell
    }

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRoomCellSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newRoomSegue" {
            let destination = segue.destination as! NewRoomViewController
            destination.delegate = self
        }
        if segue.identifier == "showRoomCellSegue" {
            let destination = segue.destination as! EditRoomViewController
            destination.currentRoom = roomArray[tableView.indexPathForSelectedRow!.row]
            destination.index = tableView.indexPathForSelectedRow!.row
        }
    }
    
    @IBAction func unwindToRoomTableViewController(segue: UIStoryboardSegue) {
    }
}
