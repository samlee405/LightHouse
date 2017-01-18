//
//  HueAPIHelper.swift
//  LightHouse
//
//  Created by Sam Lee on 1/12/17.
//  Copyright © 2017 Sam Lee. All rights reserved.
//

import Foundation
import SwiftyJSON

class HueHelper {
    static let sharedInstance = HueHelper()
    let session = URLSession.shared
    
    func getLights(completionHandler: @escaping ((_ result : [String]) -> Void)) {
        let url = URL(string: "http://172.30.5.4/api/Woco7fXdtvyLUtOcMq7WuBesSSzYzTSJz1JYXFrT/lights/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let requestedData = data {
                let convertedData = JSON(data: requestedData)
                var dataToReturn = [String]()
                for (key, _) in convertedData {
                    dataToReturn.append(key)
                }
                
                completionHandler(dataToReturn)
            }
            else {
                print("Error getting lights")
            }
        }
        
        task.resume()
    }
    
    func getGroups(completionHandler: @escaping ((_ result : [String]) -> Void)) {
        let url = URL(string: "http://172.30.5.4/api/Woco7fXdtvyLUtOcMq7WuBesSSzYzTSJz1JYXFrT/groups/")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let requestedData = data {
                let convertedData = JSON(data: requestedData)
                var dataToReturn = [String]()
                for (key, _) in convertedData {
                    dataToReturn.append(key)
                }
                
                completionHandler(dataToReturn)
            }
            else {
                print("Error getting groups")
            }
        }
        
        task.resume()
    }
    
    func turnOffLights() {
        let urlString = "http://172.30.5.4/api/Woco7fXdtvyLUtOcMq7WuBesSSzYzTSJz1JYXFrT/groups/0/action"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let dataToSend = "{\"on\": false}"
        
        request.httpBody = dataToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let requestedData = data {
                let convertedData = JSON(data: requestedData)
//                print(convertedData)
            }
            else {
                print("Error turning off all lights")
            }
        }
        
        task.resume()
    }
    
    func turnOnLights(group: String) {
        let urlString = "http://172.30.5.4/api/Woco7fXdtvyLUtOcMq7WuBesSSzYzTSJz1JYXFrT/groups/" + group + "/action"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let dataToSend = "{\"on\": true}"
        
        request.httpBody = dataToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let requestedData = data {
                let convertedData = JSON(data: requestedData)
                print(convertedData)
            }
            else {
                print("Error turning on light group")
            }
        }
        
        task.resume()
    }
    
    func createGroup(lights: [String], roomName: String) {
        let url = URL(string: "http://172.30.5.4/api/Woco7fXdtvyLUtOcMq7WuBesSSzYzTSJz1JYXFrT/groups")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataToSend = "{\"name\": \"\(roomName)\", \"type\": \"LightGroup\", \"lights\": \(lights)}"
        
        print(dataToSend)
        
        request.httpBody = dataToSend.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let requestedData = data {
                let convertedData = JSON(data: requestedData)
                print(convertedData)
            }
            else {
                print("Error creating group")
            }
        }
        
        task.resume()
    }
}
