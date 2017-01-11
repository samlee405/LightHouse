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
            for light in (cache?.lights.values)! {
                let lightState = PHLightState()
                lightState.on = false
                bridgeSendAPI.updateLightState(forId: (light as AnyObject).identifier, with: lightState, completionHandler: { (error: [Any]?) in
                    if error != nil {
                        print(error)
                    }
                })
            }
            
            loop: for room in roomArray {
                if room.roomBeacon == String(describing: closestBeacon) {
                    for light in room.roomLights {
                        let lightState = PHLightState()
                        lightState.on = true
                        bridgeSendAPI.updateLightState(forId: light.lightID, with: lightState, completionHandler: { (error: [Any]?) in
                            if error != nil {
                                print(error)
                            }
                        })
                    }
                    break loop
                }
            }
        }
    }
    
    let cache = PHBridgeResourcesReader.readBridgeResourcesCache()
    let bridgeSendAPI = PHBridgeSendAPI()
    
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
        cell.roomTitleLabel.text = roomArray[indexPath.row].roomTitle
        cell.currentBeacon = roomArray[indexPath.row].roomBeacon
        cell.lightsArray = roomArray[indexPath.row].roomLights

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
