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
    
    func getRainbow(section:Int) -> UIColor {
        if section == 0 {
            return .red
        }
        if section == 1 {
            return .orange
        }
        if section == 2 {
            return .yellow
        }
        if section == 3 {
            return .green
        }
        if section == 4 {
            return .blue
        }
        if section == 5 {
            return .magenta
        }
        if section == 6 {
            return .purple
        }
        return .clear
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
