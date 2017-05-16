//
//  SendDataBoxOrange.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 16..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 위젯에 넘기는 용으로 쓰는 것 */
struct GroupKeys {
    let cardID = "1"
    let suiteName = "group.com.baecheese.app.forppu"
    let cardName = "cardName"
    let cardNumber = "cardNumber"
    let image = "barCodeImage"
}

class SendDataBoxOrange: NSObject {

    private override init() {
        super.init()
    }
    
    static let sharedInstance:SendDataBoxOrange = SendDataBoxOrange()
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
    
    func showBarCode(cardNumber:String) -> UIImage? {
        if cardNumber.characters.count < 1 {
            return nil
        }
        let asciiEncodedValue = cardNumber.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(asciiEncodedValue, forKey: "inputMessage")
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
    private func fromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getMainColor() -> UIColor {
        return fromRGB(rgbValue: 0xFCB571)
    }
}
