//
//  ColorManager.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class ColorManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance:ColorManager = ColorManager()
    
    func getMainBackImage() -> UIColor {
//        return fromRGB(rgbValue: 0x26140C)
        return UIColor(patternImage: UIImage(named: "leather_patten2")!)
    }
    
    func getTint() -> UIColor {
        return .lightGray
    }
    
    func getRainbow(section:Int) -> UIColor {
        if section == 0 {
            return fromRGB(rgbValue: 0xF15A5A)
        }
        if section == 1 {
            return fromRGB(rgbValue: 0xFCB571)
        }
        if section == 2 {
            return fromRGB(rgbValue: 0xFFF670)
        }
        if section == 3 {
            return fromRGB(rgbValue: 0x4EBA6F)
        }
        if section == 4 {
            return fromRGB(rgbValue: 0x2D95BF)
        }
        if section == 5 {
            return fromRGB(rgbValue: 0x325583)
        }
        if section == 6 {
            return fromRGB(rgbValue: 0x955BA5)
        }
        return .clear
    }
    
    func getInfoColor(menu:Int) -> UIColor {
        if menu == 0 {
            return fromRGB(rgbValue: 0xB64926)
        }
        if menu == 1 {
            return fromRGB(rgbValue: 0x468966)
        }
        return .white
    }
    
    func fromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
