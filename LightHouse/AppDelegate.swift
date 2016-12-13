//
//  AppDelegate.swift
//  LightHouse
//
//  Created by Sam Lee on 11/17/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?

    let beaconManager = ESTBeaconManager()
    let hueManager = PHHueSDK()
    
    var bridgeSearch = PHBridgeSearching()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        self.hueManager.enableLogging(true)
        self.hueManager.startUp()
        
        let notificationManager: PHNotificationManager = PHNotificationManager.default()
        
        notificationManager.register(self, with: #selector(self.localConnection), forNotification: LOCAL_CONNECTION_NOTIFICATION)
        notificationManager.register(self, with: #selector(self.noLocalConnection), forNotification: NO_LOCAL_CONNECTION_NOTIFICATION)
        notificationManager.register(self, with: #selector(self.notAuthenticated), forNotification: NO_LOCAL_AUTHENTICATION_NOTIFICATION)
        notificationManager.register(self, with: #selector(self.authenticationSuccess), forNotification: PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION)
        notificationManager.register(self, with: #selector(self.authenticationFailed), forNotification: PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION)
        notificationManager.register(self, with: #selector(self.noLocalConnection), forNotification: PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION)
        notificationManager.register(self, with: #selector(self.noLocalBridge), forNotification: PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION)
        notificationManager.register(self, with: #selector(self.buttonNotPressed), forNotification: PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION)

        
        enableHeartBeat()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        enableHeartBeat()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Notification receivers
    
    func localConnection() {
        if !hueManager.localConnected() {
            // Handle error
        }
        else {
            print("Pushlink Success")
        }
    }
    
    func noLocalConnection() {
        if !hueManager.localConnected() {
            // Handle error
        }
        else {
            print("Pushlink Success")
        }
    }
    
    func notAuthenticated() {
//        PHNotificationManager.default().deregisterObject(forAllNotifications: self)
        doAuthentication()
    }
    
    func doAuthentication() {
        disableHeartBeat()
        hueManager.startPushlinkAuthentication()
    }
    
    func authenticationSuccess() {
        PHNotificationManager.default().deregisterObject(forAllNotifications: self)
        enableHeartBeat()
    }
    
    func authenticationFailed() {
        PHNotificationManager.default().deregisterObject(forAllNotifications: self)
        print("Bridge authentication failed. Please try again")
    }
    
    func noLocalBridge() {
        PHNotificationManager.default().deregisterObject(forAllNotifications: self)
        print("No local bridge found")
    }
    
    func buttonNotPressed() {
        // Notification that sync process is waiting for user to press button on the bridge
    }
    
    // MARK: - Bridge connection handling
    
    func enableHeartBeat() {
        
        let cache: PHBridgeResourcesCache? = PHBridgeResourcesReader.readBridgeResourcesCache()
        if (cache != nil) && (cache?.bridgeConfiguration != nil) && (cache?.bridgeConfiguration.ipaddress != nil) {
            hueManager.enableLocalConnection()
        }
        else {
            searchForNewBridge()
        }
    }
    
    func disableHeartBeat() {
        hueManager.disableLocalConnection()
    }

    func searchForNewBridge() {
        disableHeartBeat()
        self.bridgeSearch = PHBridgeSearching(upnpSearch: true, andPortalSearch: true, andIpAddressSearch: true)
        self.bridgeSearch.startSearch { (bridgesFound: [AnyHashable : Any]?) in
            if (bridgesFound?.count)! > 0 {
                var bridgeID: String?
                var bridgeIP: String?
                for key in (bridgesFound?.keys)! {
                    bridgeID = String(describing: key)
                    bridgeIP = String(describing: bridgesFound?[key])
                    break
                }
                
                self.hueManager.setBridgeToUseWithId(bridgeID, ipAddress: bridgeIP)
                
                self.enableHeartBeat()
            }
        }
    }

}








