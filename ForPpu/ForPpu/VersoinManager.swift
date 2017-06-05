//
//  VersoinManager.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 6. 5..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class VersoinManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance:VersoinManager = VersoinManager()
    
    func checkUpdate() -> Bool {
//        let defaults = UserDefaults()
//        let savedUpdateVersion = defaults.value(forKey: "update") as? String
//        if savedUpdateVersion == getVersion() {
//            return true
//        }
//        else {
//            return false
//        }
        return false
    }
    
    func setCheckUpdate() {
        let defaults = UserDefaults()
        defaults.set(getVersion(), forKey: "update")
        print("setCheckUpdate - \(getVersion())")
    }
    
    private func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
}
