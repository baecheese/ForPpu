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
        let cardName = data?.0
        let cardNumber = data?.1
        
        if nil == cardName || nil == cardNumber {
            return nil
        }
        
        return (cardName!, cardNumber!)
    }
    
    func getBardCodeImage(cardID:Int) -> UIImage? {
        if nil == wedgetDataCenter.getSavedBarCodeImageData(cardID: cardID) {
            return nil
        }
        return UIImage(data: wedgetDataCenter.getSavedBarCodeImageData(cardID: cardID)!)
    }
    
    func deleteData(cardID:Int) {
        wedgetDataCenter.deleteCardInfo(cardID: cardID)
        wedgetDataCenter.deleteImage(cardID: cardID)
    }
    
    
}
