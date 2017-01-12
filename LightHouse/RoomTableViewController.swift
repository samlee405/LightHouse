//
//  RoomTableViewController.swift
//  LightHouse
//
//  Created by Sam Lee on 11/29/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

class RoomTableViewController: UITableViewController, NewRoomViewControllerDelegate, CLLocationManagerDelegate {
    
    var roomArray = [Room]()
    
    var closestBeacon: CLBeacon? {
        didSet {
            // turn off all lights
            // may need to create closure due to asychronous-ny
            HueHelper.sharedInstance.turnOffLights()
            
            // turn on lights for the room we're walking into
            loop: for room in roomArray {
                if room.roomBeacon == closestBeacon {
                    let currentRoom = room.roomBeacon
                    
                    break loop
                }
            }
        }
    }
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "test")

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
    }
    
    func addNewRoom(room: Room) {
        roomArray.append(room)
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
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
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showRoomCellSegue", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
