//
//  EstimoteHelper.swift
//  LightHouse
//
//  Created by fnord on 12/6/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class EstimoteHelper: NSObject, ESTBeaconManagerDelegate, ESTDeviceManagerDelegate, ESTDeviceConnectableDelegate {
    
    var beaconManager = ESTBeaconManager()
    var deviceManager = ESTDeviceManager()
    var device: ESTDeviceLocationBeacon!
    var beaconRegion = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "ranged region")
    
    private var isWriting = false
    
    private var writeVal: Int?
    
    private var onWrite: ((Bool) -> ())
    private var gotNearestBeacon: ((ESTDeviceLocationBeacon) -> ())
    
    override init(){
        super.init()
        self.beaconManager.delegate = self
        self.beaconManager.avoidUnknownStateBeacons = true
        
        self.deviceManager.delegate = self
        
        self.beaconManager.requestAlwaysAuthorization()
        
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    func endRanging() {
        self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
    }
    

    func writeLightGroupToNearestBeacon(lightGroupNumber: Int, completion: (Bool) -> ()){
        self.isWriting = true
        self.writeVal = lightGroupNumber
        self.onWrite = completion

        let deviceFilter = ESTDeviceFilterLocationBeacon()
        self.deviceManager.startDeviceDiscovery(with: deviceFilter)
    }
    
    func getNearestBeacon(completion: (ESTDeviceLocationBeacon) -> ()){
        self.gotNearestBeacon = completion
        
        let deviceFilter = ESTDeviceFilterLocationBeacon()
        self.deviceManager.startDeviceDiscovery(with: deviceFilter)
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon],
                       in region: CLBeaconRegion) {
        places = beacons
        delegate?.beaconsFound!(beacons: beacons)
    }
    
    func deviceManager(_ manager: ESTDeviceManager,
                       didDiscover devices: [ESTDevice]) {
        self.deviceManager.stopDeviceDiscovery()
        
        if isWriting{
            var orderedDevices: [ESTDevice]
            
            if devices.count > 0 {
                orderedDevices = devices.sorted(by: { (ldevice, rdevice) -> Bool in
                    return ldevice.rssi > rdevice.rssi
                })
               
                let nearestDevice = orderedDevices.first
                nearestDevice.delegate = self
                nearestDevice.connect()
            }
        }else{
            var orderedDevices: [ESTDevice]
            
            if devices.count > 0 {
                orderedDevices = devices.sorted(by: { (ldevice, rdevice) -> Bool in
                    return ldevice.rssi > rdevice.rssi
                })
                
                let nearestDevice = orderedDevices.first
                self.gotNearestBeacon(nearestDevice)
            }
        }
    }
    
    func estDeviceConnectionDidSucceed(_ device: ESTDeviceConnectable) {
        print("Connected")
        if isWriting{
            let estdevice = (device as! ESTDeviceLocationBeacon)
            estdevice.settings?.iBeacon.minor.writeValue(self.writeVal, completion: { (value, error) in
                self.isWriting = false
                if error != nil{
                    print(error)
                    onWrite(false)
                }else{
                    onWrite(true)
                }
            })
        }
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
