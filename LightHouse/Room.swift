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
    var roomBeacon: CLBeacon
    var roomLights = [Light]()
    
    init(name: String, roomBeacon: CLBeacon?) {
        self.roomTitle = name
        self.roomBeacon = roomBeacon ?? CLBeacon()
    }
    
    // What adding a light to a room really does is add the uuid of the light to the broadcast string of the estimote associated with the room
    func addLightToRoom(light: Light){
        roomLights.append(light)
        
        EstimoteHelper().writeLights(lights: roomLightDictBuilder())
    }
    
    private func roomLightDictBuilder() -> Dictionary<String, String>{
        var lights: [String: String] = [:]
       
        self.roomLights.map{ lights[$0.lightID] = "" }
        
        return lights
    }
}
