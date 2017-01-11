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
        
        var broadcastString = roomLightStringBuilder()
        
        EstimoteHelper().get
        
        
    }
    
    private func roomLightStringBuilder() -> String{
        var broadcastString = "" //consists of the room name followed by a list of room light identifiers (formatted as JSON maybe?)
        
        broadcastString.append(roomTitle)
        
        for light in self.roomLights{
            //TODO: Sam, write this shiz
        }
        
        return broadcastString
    }
}
