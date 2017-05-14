//
//  SendDataBoxThree.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 14..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 위젯에 넘기는 용으로 쓰는 것 */
struct GroupKeys {
    let cardID = "2"
    let suiteName = "group.com.baecheese.app.forppu"
    let cardName = "cardName"
    let cardNumber = "cardNumber"
    let image = "barCodeImage"
}

class SendDataBoxThree: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance:SendDataBoxThree = SendDataBoxThree()
    let userDefault = UserDefaults(suiteName: GroupKeys().suiteName)
    
    func getCardInfo() -> (String, String)? {
        let keys = getKeys()
        let cardName = userDefault?.value(forKey: keys[0])
        let cardNumber = userDefault?.value(forKey: keys[1])
        if nil != cardName && nil != cardNumber {
            return (cardName!, cardNumber!) as? (String, String)
        }
        return nil
    }
    
    /** 0:이름키, 1:번호키, 2:이미지키 */
    private func getKeys() -> [String] {
        let keys = GroupKeys()
        let cardNameKey = "\(keys.cardID)_\(keys.cardName)"
        let cardNumberKey = "\(keys.cardID)_\(keys.cardNumber)"
        let barCodeImageKey = "\(keys.cardID)_\(keys.image)"
        return [cardNameKey, cardNumberKey, barCodeImageKey]
    }
}