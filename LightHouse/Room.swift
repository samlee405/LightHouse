//
//  Room.swift
//  LightHouse
//
//  Created by Sam Lee on 11/29/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import Foundation

class Room {
    var roomTitle: String
    var roomBeacon: String?
    var roomLights = [Light]()
    
    init(name: String) {
        roomTitle = name
    }
}
