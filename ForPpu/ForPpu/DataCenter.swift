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

    // key: cardID value: (cardName, cardNumber)
    func setCardInfo(cardID:Int, cardName:String, cardNumber:String) {
        
    }
    
}
