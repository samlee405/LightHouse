//
//  EstimoteHelper.swift
//  LightHouse
//
//  Created by fnord on 12/6/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

protocol EstimoteHelperDelegate {
    func beaconsFound(beacons: [CLBeacon])
}

class EstimoteHelper: NSObject, ESTBeaconManagerDelegate, ESTDeviceManagerDelegate, ESTDeviceConnectableDelegate {
    
    var beaconManager = ESTBeaconManager()
    var deviceManager = ESTDeviceManager()
    var device: ESTDeviceLocationBeacon!
    var beaconRegion = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "ranged region")
    
    var places: [CLBeacon] = [CLBeacon]()
    
    var delegate: EstimoteHelperDelegate?
    
    override init(){
        super.init()
        self.beaconManager.delegate = self
        self.beaconManager.avoidUnknownStateBeacons = true
        
        self.deviceManager.delegate = self
        
        let deviceIdentifier = getNearestEstimote()?.proximityUUID.uuidString
        let deviceFilter = ESTDeviceFilterLocationBeacon(
            identifier: deviceIdentifier!)
        self.deviceManager.startDeviceDiscovery(with: deviceFilter)
        
        self.beaconManager.requestAlwaysAuthorization()
        
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    func endRanging() {
        self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
    }
    
    func getNearestEstimote()->CLBeacon?{
        self.places.sort { (a, b) -> Bool in
            a.proximity.rawValue > b.proximity.rawValue
        }
        
        return self.places.first
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon],
                       in region: CLBeaconRegion) {
        places = beacons
        delegate?.beaconsFound(beacons: beacons)
    }
    
    
    func deviceManager(_ manager: ESTDeviceManager,
                       didDiscover devices: [ESTDevice]) {
        guard let device = devices.first as? ESTDeviceLocationBeacon else { return }
        self.deviceManager.stopDeviceDiscovery()
        self.device = device
        
        self.device.delegate = self
        self.device.connect()
    }
    
    func estDeviceConnectionDidSucceed(_ device: ESTDeviceConnectable) {
        print("Connected")
        self.device.
    }
    
    func estDevice(_ device: ESTDeviceConnectable,
                   didFailConnectionWithError error: Error) {
        print("Connnection failed with error: \(error)")
    }
    
    func estDevice(_ device: ESTDeviceConnectable,
                   didDisconnectWithError error: Error?) {
        print("Disconnected")
        // disconnection can happen via the `disconnect` method
        //     => in which case `error` will be nil
        // or for other reasons
        //     => in which case `error` will say what went wrong
    }
}
