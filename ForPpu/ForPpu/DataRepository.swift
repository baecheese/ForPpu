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

    // barcode number -> barcode image
    func showBarCodeImage(cardNumber string: String) -> UIImage? {
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
    
    func delete(cardID:String) {
        wedgetDataCenter.deleteCardInfo(cardID: cardID)
    }

    /** key: cardID value: (cardName, cardNumber)? */
    func getSelectWidgetInfo() -> (String, String)? {
        let selectCardID = wedgetDataCenter.getFullScreenBarcode()
        let data = wedgetDataCenter.get(cardID: selectCardID!)
        let cardName = data?.0
        let cardNumber = data?.1
        if nil == cardNumber || nil == cardName {
            return nil
        }
        return (cardName!, cardNumber!)
    }
    
    func getSelectWidgetCardId() -> String? {
        return wedgetDataCenter.getFullScreenBarcode()
    }
    
    func deleteBeforeSelectCardInfo() {
        wedgetDataCenter.deleteFullScreenBarcode()
    }
    
}
