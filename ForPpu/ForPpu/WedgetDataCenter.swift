//
//  WedgetDataCenter.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 위젯과의 데이터 교류 용 */
struct GroupKeys {
    let suiteName = "group.com.baecheese.app.forppu"
    let cardName = "cardName"
    let cardNumber = "cardNumber"
    let image = "barCodeImage"
    let selectCardId = "selectCardId"
}

class WedgetDataCenter: NSObject {
    
    override init() {
        super.init()
    }
    
    private let defaults = UserDefaults(suiteName: GroupKeys().suiteName)
    let keys = GroupKeys()
    
    /** let key = "\(keys.cardID)_\(keys.cardName)"*/
    func set(cardID:String, cardName:String, cardNumber:String) {
        let keys = getKeys(cardID: cardID)
        let newCardName = cardName
        let newCardNumber = cardNumber
        
        if 1 <= newCardName.characters.count {
            defaults?.set(newCardName, forKey: keys[0])
        }
        if 1 <= newCardNumber.characters.count {
            defaults?.set(newCardNumber, forKey: keys[1])
        }
        
//        defaults?.set(getImageData(cardNumber: cardNumber), forKey: keys[2])
    }
    
    
    func setAndGet(cardID:String, cardName:String, cardNumber:String) -> (String, String)?  {
        let keys = getKeys(cardID: cardID)
        defaults?.set(cardName, forKey: keys[0])
        defaults?.set(cardNumber, forKey: keys[1])
//        defaults?.set(getBarCodeImage(cardNumber: cardNumber), forKey: keys[2])
        return get(cardID: cardID)
    }
    
    /** (cardName, cardNumber) */
    func get(cardID:String) -> (String, String)? {
        let keys = getKeys(cardID: cardID)
        let cardName = defaults?.value(forKey: keys[0])
        let cardNumber = defaults?.value(forKey: keys[1])
        if nil != cardName || nil != cardNumber {
            return (cardName as! String, cardNumber as! String)
        }
        return nil
    }
    
    func deleteCardInfo(cardID:String) {
        defaults?.removeObject(forKey: getKeys(cardID: cardID)[0])
        defaults?.removeObject(forKey: getKeys(cardID: cardID)[1])
    }
    
    /** 0:이름키, 1:번호키, 2:이미지키 */
    private func getKeys(cardID:String) -> [String] {
        let cardNameKey = "\(cardID)_\(keys.cardName)"
        let cardNumberKey = "\(cardID)_\(keys.cardNumber)"
        let barCodeImageKey = "\(cardID)_\(keys.image)"
        return [cardNameKey, cardNumberKey, barCodeImageKey]
    }
    
    func getFullScreenBarcode() -> String? {
        return defaults?.value(forKey: keys.selectCardId) as? String
    }
    
    func deleteFullScreenBarcode() {
        if nil != getFullScreenBarcode() {
            defaults?.set(nil, forKey: keys.selectCardId)
        }
    }
    
}
