//
//  RoomTableViewController.swift
//  LightHouse
//
//  Created by Sam Lee on 11/29/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

class RoomTableViewController: UITableViewController, NewRoomViewControllerDelegate, ESTBeaconManagerDelegate, CLLocationManagerDelegate {
    
    var roomArray = [Room]()
    
    var beaconRssiAverage: [Int: Int] = [:]
    
    var beaconRssiTotals: [Int: [Int]] = [:]
    
    var iterators: [Int: Int] = [:]
    
    let locationManager = CLLocationManager()
    
    var closestBeacon: CLBeacon? {
        didSet {

//             turn off all lights
//             may need to create closure for turning on the lights due to asychronousness
            if let unwrappedOldValue = oldValue?.minor.intValue {
                if unwrappedOldValue != (closestBeacon?.minor.intValue)! {
                    HueHelper.sharedInstance.turnOffLightsForGroup(group: (unwrappedOldValue))
                    HueHelper.sharedInstance.turnOnLights(group: (closestBeacon?.minor.intValue)!)
                }
            }
            
            // turn on lights for the room we're walking into

            
        }
    }
    
    let beaconManager = (UIApplication.shared.delegate as! AppDelegate).beaconManager
    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "test")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeacons(in: region)
        beaconManager.delegate = self
        
        beaconManager.startRangingBeacons(in: region)
//         Initilize tableView with any existing rooms in the bridge
        HueHelper.sharedInstance.getGroups { (result) in
            for room in result {
                self.roomArray.append(room)
            }
         
            self.tableView.reloadData()
        }
    }
    
    func addNewRoom(room: Room) {
        roomArray.append(room)
        tableView.reloadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {        let knownBeacons = beacons.filter{ $0.rssi != 0 }
        
        for beacon in knownBeacons{
            if iterators[beacon.minor.intValue] == nil{
                iterators[beacon.minor.intValue] = 0
                beaconRssiTotals[beacon.minor.intValue] = [Int](repeating: 0, count: 2)
            }
            
            if iterators[beacon.minor.intValue]! >= 2{
                iterators[beacon.minor.intValue] = 0
            }
            
            beaconRssiTotals[beacon.minor.intValue]?[iterators[beacon.minor.intValue]!] = beacon.rssi
            beaconRssiAverage[beacon.minor.intValue] = (beaconRssiTotals[beacon.minor.intValue]?.reduce(0, +))!/(beaconRssiTotals[beacon.minor.intValue]?.count)!
            iterators[beacon.minor.intValue]! += 1
        }
       
        for beacon in knownBeacons{
            
            let maxAverage = beaconRssiAverage.values.max()
            var maxMinor: Int?
            
            for (key, value) in beaconRssiAverage{
                if value == maxAverage{
                    maxMinor = key
                }
            }
            
            if beacon.minor.intValue == maxMinor{
                closestBeacon = beacon
                print(closestBeacon)
            }
            
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as! RoomTableViewCell
        let cellRoom = self.roomArray[indexPath.row]
       
        cell.roomTitleLabel.text = cellRoom.roomTitle
//        cell.currentBeacon = cellRoom.roomBeacon.proximityUUID.uuidString
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
