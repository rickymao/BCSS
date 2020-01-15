//
//  NetworkController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-09-20.
//  Copyright © 2019 Ricky Mao. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SystemConfiguration

class NetworkController {
    
    init() {
        
    }
    
    //Check for a connection and pops an actionvc to help users connect to WiFi if they are not
    func checkWiFi() -> Bool {
        
        //Check wifi
        return isReachable()
    }
    
    
    let reachability = SCNetworkReachabilityCreateWithName(nil, "https://www.youtube.com")
    
    func openSettings() {
        
        let shared = UIApplication.shared
        if let url = URL(string: UIApplication.openSettingsURLString) {
            
            shared.open(url, options: [:]) { (success) in
                
            }
        }
        
        
    }
    
    //Checks for network reachability and connections
    func isReachable() -> Bool {
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)
        
        if (canConnect(with: flags)) {
            
            print(flags)
            if flags.contains(.isWWAN){
                return true
            }
            print("wifi")
            return true
        }
        else if (!canConnect(with: flags)) {
            
            print("no connection")
            print(flags)
            return false
        } else {
            return false
        }
        
    }
    
    func canConnect(with flags: SCNetworkReachabilityFlags) -> Bool {
        
        let isReachable = flags.contains(.reachable)
        let needConnection = flags.contains(.connectionRequired)
        let canConnectAuto = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUser = canConnectAuto && !flags.contains(.interventionRequired)
        
        return isReachable && (!needConnection || canConnectWithoutUser)
        
        
    }
    
    

    
    
    
}
