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
    
    func set(cardID:String, cardName:String, cardNumber:String) {
        wedgetDataCenter.set(cardID: cardID, cardName: cardName, cardNumber: cardNumber)
    }
    
    /** key: cardID value: (cardName, cardNumber)? */
    func setAndGet(cardID:String, cardName:String, cardNumber:String) -> (String, String)? {
        wedgetDataCenter.set(cardID: cardID, cardName: cardName, cardNumber: cardNumber)
        return get(cardID: cardID)
    }
    
    /** key: cardID value: (cardName, cardNumber)? */
    func get(cardID:String) -> (String, String)? {
        let data = wedgetDataCenter.get(cardID: cardID)
        let cardName = data?.0
        let cardNumber = data?.1
        
        if nil == cardName || nil == cardNumber {
            return nil
        }
        
        return (cardName!, cardNumber!)
    }
    
    func showBarCodeImage(cardNumber:String) -> UIImage? {
        if cardNumber.characters.count < 1 {
            return nil
        }
        let asciiEncodedValue = cardNumber.data(using: .ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(asciiEncodedValue, forKey: "inputMessage")
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
    func delete(cardID:String) {
        wedgetDataCenter.deleteCardInfo(cardID: cardID)
    }

    /** key: cardID value: (cardName, cardNumber)? */
    func getSelectWidgetInfo() -> (String, String)? {
        let selectCardID = wedgetDataCenter.getFullScreenBarcode()
        if nil == selectCardID {
            return nil
        }
        let data = wedgetDataCenter.get(cardID: selectCardID!)
        let cardName = data?.0
        let cardNumber = data?.1
        return (cardName!, cardNumber!)
    }
    
    func getSelectWidgetCardId() -> String? {
        return wedgetDataCenter.getFullScreenBarcode()
    }
    
    func deleteBeforeSelectCardInfo() {
        wedgetDataCenter.deleteFullScreenBarcode()
    }
    
}
