//
//  WedgetDataCenter.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 위젯에 넘기는 용으로 쓰는 것 */
struct GroupKeys {
    let suiteName = "group.com.baecheese.ForPpu"
    let cardID = "cardID"
    let cardName = "cardName"
    let cardNumber = "cardNumber"
    let image = "barCodeImage"
}

class WedgetDataCenter: NSObject {
    
    override init() {
        super.init()
    }
    
    private let defaults = UserDefaults(suiteName: GroupKeys().suiteName)
    let keys = GroupKeys()
    
    func set(cardID:Int, cardName:String, cardNumber:String) {
        let info:[String:Any?] = [keys.cardName:cardName, keys.cardNumber:cardNumber, keys.image:getBarCodeImage(cardNumber: cardNumber)]
        let infoAny = info as Any
        defaults?.setValue(infoAny, forKey: "\(cardID)")
        defaults?.set(infoAny, forKey: "\(cardID)")
    }
    
    /** key: cardID value: [cardKey:Value, key:value .. ] */
    func setAndGet(cardID:Int, cardName:String, cardNumber:String) -> [String:Any?]? {
        let info:[String:Any?] = [keys.cardName:cardName, keys.cardNumber:cardNumber, keys.image:getBarCodeImage(cardNumber: cardNumber)]
        defaults?.set(info, forKey: "\(cardID)")
        return get(cardID: cardID)
    }
    
    /** key: cardID value: [cardKey:Value, key:value .. ] */
    func get(cardID:Int) -> [String:Any?]? {
        if defaults?.value(forKey: "\(cardID)") == nil {
            return nil
        }
        return defaults?.value(forKey: "\(cardID)") as? [String : Any?]
    }
    
    private func getBarCodeImage(cardNumber:String) -> UIImage? {
        // 바코드 사진 생성 후
        return nil
    }

}
