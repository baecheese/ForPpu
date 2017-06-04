//
//  ScreenBrightnessManager.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 6. 4..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class ScreenBrightnessManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance:ScreenBrightnessManager = ScreenBrightnessManager()
    
    func setBeforeScreenBrightness(brightness:CGFloat) {
        SharedMemoryContext.set(key: Key().screenBrightness, setValue: UIScreen.main.brightness)
    }
    
    func getBeforeScreenBrightness() -> CGFloat {
        let brightness = SharedMemoryContext.get(key: Key().screenBrightness)
        if nil == brightness {
            setBeforeScreenBrightness(brightness: UIScreen.main.brightness)
            return getBeforeScreenBrightness()
        }
        return brightness as! CGFloat
    }
    
    func setFullScreenMode() {
        UIScreen.main.brightness = CGFloat(1.0)
    }
    
    func goBackBeforeBrightness() {
        UIScreen.main.brightness = getBeforeScreenBrightness()
    }
    
}
