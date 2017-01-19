//
//  Room.swift
//  LightHouse
//
//  Created by Sam Lee on 11/29/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class Room {
    var estimoteHelper = EstimoteHelper()
    var roomTitle: String
    var roomBeacon: CLBeacon
    var roomLights = [String]()
    var groupNumber: Int?
    
    init(name: String, roomBeacon: CLBeacon?) {
        self.roomTitle = name
        self.roomBeacon = roomBeacon ?? CLBeacon()
    }
    
    func setLightGroup(lightGroupNumber: Int){
        estimoteHelper.writeLightGroupToNearestBeacon(lightGroupNumber: lightGroupNumber){(success) in
            if success{
                print("light group set to " + self.roomTitle)
            }else{
                print("light group set failed")
            }
        }
    }
}
