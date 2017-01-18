//
//  Room.swift
//  LightHouse
//
//  Created by Sam Lee on 11/29/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class Room: EstimoteHelperDelegate {
    var roomTitle: String
    var roomBeacon: CLBeacon
    var roomLights = [String]()
    var groupNumber: Int?
    
    init(name: String, roomBeacon: CLBeacon?) {
        self.roomTitle = name
        self.roomBeacon = roomBeacon ?? CLBeacon()
    }
}
