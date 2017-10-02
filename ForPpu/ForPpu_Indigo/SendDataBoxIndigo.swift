//
//  SendDataBoxIndigo.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 16..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 위젯에 넘기는 용으로 쓰는 것 */
struct GroupKeys {
    let cardID = "5"
    let suiteName = "group.com.baecheese.app.forppu"
    let cardName = "cardName"
    let cardNumber = "cardNumber"
    let image = "barCodeImage"
    let selectCardId = "selectCardId"
}

class SendDataBoxIndigo: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance:SendDataBoxIndigo = SendDataBoxIndigo()
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
    
    // barcode number -> barcode image
    func showBarCode(cardNumber string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setDefaults()
            //Margin
            filter.setValue(7.00, forKey: "inputQuietSpace")
            filter.setValue(data, forKey: "inputMessage")
            
            //Scaling
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                let context:CIContext = CIContext.init(options: nil)
                let cgImage:CGImage = context.createCGImage(output, from: output.extent)!
                let rawImage:UIImage = UIImage.init(cgImage: cgImage)
                let cgimage:CGImage = (rawImage.cgImage)!
                let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
                let cropZoneWidth:size_t  = size_t(cropZone.size.width)
                let cropZoneHeight:size_t  = size_t(cropZone.size.height)
                let bitsPerComponent: size_t = cgimage.bitsPerComponent
                
                let bytesPerRow = (cgimage.bytesPerRow) / (cgimage.width  * cropZoneWidth)
                
                let resultContext:CGContext = CGContext(data: nil, width: cropZoneWidth, height: cropZoneHeight, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: cgimage.bitmapInfo.rawValue)!
                resultContext.draw(cgimage, in: cropZone)
                
                let result:CGImage = resultContext.makeImage()!
                let finalImage = UIImage(cgImage: result)
                
                return finalImage
            }
        }
        return nil
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
        return fromRGB(rgbValue: 0x325583)
    }
    
    func setSelectBarcode() {
        userDefault?.set(GroupKeys().cardID, forKey: GroupKeys().selectCardId)
    }
}
