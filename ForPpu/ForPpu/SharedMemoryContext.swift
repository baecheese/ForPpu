//
//  File.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 사용중인 key : "cardID"(Int) = section */

struct Key {
    let cardID = "cardID"
}

public struct SharedMemoryContext {
    
    private static var context:[String:Any?] = Dictionary()
    
    public static func getCardID() -> Any? {
        let cardID = Key().cardID
        if context[cardID] == nil {
            return nil
        }
        return context[cardID]!
    }
    
    public static func setCardID(setValue:Any) {
        let cardID = Key().cardID
        if context[cardID] != nil {
            changeValue(value: setValue)
            return;
        }
        context.updateValue(setValue, forKey: cardID)
    }
    
    public static func setAndGetCardID(setValue:Any) -> Any {
        let cardID = Key().cardID
        if context[cardID] != nil {
            changeValue(value: setValue)
            return setValue
        }
        context.updateValue(setValue, forKey: cardID)
        return setValue
    }
    
    private static func changeValue(value:Any) {
        let cardID = Key().cardID
        context[cardID] = value
    }
    
}
