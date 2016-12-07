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
    var roomBeacon: ESTDevice
    var roomLights = [Light]()
    
    init(name: String, roomBeacon: ESTDevice?) {
        self.roomTitle = name
        self.roomBeacon = roomBeacon ?? ESTDevice()
    }
    
    // What adding a light to a room really does is add the uuid of the light to the broadcast string of the estimote associated with the room
    func addLightToRoom(light: Light){
        roomLights.append(light)
        
        var broadcastString = roomLightStringBuilder()
        
        
    }
    
    private func roomLightStringBuilder() -> String{
        var broadcastString = "" //consists of the room name followed by a list of room light identifiers (formatted as JSON maybe?)
        
        broadcastString.append(roomTitle)
        
        for light in self.roomLights{
            //Takes the UUID of the light and adds it to the broadcast string
        }
        
        return broadcastString
    }
}
