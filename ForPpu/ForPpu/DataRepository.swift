//
//  DataRepository.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class DataRepository: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance:DataRepository = DataRepository()
    let wedgetDataCenter = WedgetDataCenter()
    let keys = GroupKeys()
    
    func set(cardID:Int, cardName:String, cardNumber:String) {
        wedgetDataCenter.set(cardID: cardID, cardName: cardName, cardNumber: cardNumber)
    }
    
    /** key: cardID value: (cardName, cardNumber)? */
    func setAndGet(cardID:Int, cardName:String, cardNumber:String) -> (String, String)? {
        wedgetDataCenter.set(cardID: cardID, cardName: cardName, cardNumber: cardNumber)
        return get(cardID: cardID)
    }
    
    /** key: cardID value: (cardName, cardNumber)? */
    func get(cardID:Int) -> (String, String)? {
        let data = wedgetDataCenter.get(cardID: cardID)
        let cardName = data?[keys.cardName] as? String
        let cardNumber = data?[keys.cardNumber] as? String
        
        if nil == cardName || nil == cardNumber {
            return nil
        }
        
        return (cardName!, cardNumber!)
    }
    
    
}
