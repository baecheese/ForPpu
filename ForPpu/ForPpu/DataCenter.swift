//
//  DataCenter.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class DataCenter: NSObject {
    
    private override init() {
        super.init()
    }

    let defaults = UserDefaults.standard
    
    static let sharedInstance:DataCenter = DataCenter()

    func set(cardID:Int, cardName:String, cardNumber:String) {
        defaults.set((cardName, cardNumber), forKey: "\(cardID)")
    }
    
    /** key: cardID value: (cardName, cardNumber)? */
    func setAndGet(cardID:Int, cardName:String, cardNumber:String) -> (String, String)? {
        defaults.set((cardName, cardNumber), forKey: "\(cardID)")
        return get(cardID: cardID)
    }
    
    func get(cardID:Int) -> (String, String)? {
        if defaults.value(forKey: "\(cardID)") == nil {
            return nil
        }
        return defaults.value(forKey: "\(cardID)") as? (String, String)
    }
    
}
