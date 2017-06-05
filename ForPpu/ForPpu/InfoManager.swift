//
//  InfoManager.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 6. 4..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct InfoMenu {
    let saveAndDelete = NSLocalizedString("saveAndDelete", tableName: "Korean", value: "Save & Delete", comment: "저장/삭제 방법")
    let fullSize = NSLocalizedString("showFullSize", tableName: "Korean", value: "To view full size barcode images", comment: "바코드 크게 보기")
}

class InfoManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance:InfoManager = InfoManager()
    
    let saveAndDelete = 0
    let fullScreenMode = 1
    let updateInfo = 1990
    
    func getInfoMenu() -> [String] {
        let infoMenu = InfoMenu()
        return [infoMenu.saveAndDelete, infoMenu.fullSize]
    }
    
    func getInfoImageList(info:Int) -> [UIImage] {
        if 0 == info {
            return [UIImage(named: "saveInfo_1.png")!, UIImage(named: "saveInfo_2.png")!, UIImage(named: "saveInfo_3.png")!, UIImage(named: "saveInfo_4.png")!]
        }
        if 1 == info {
            return [UIImage(named: "update_1.png")!, UIImage(named: "update_2.png")!]
        }
        return [UIImage(named: "cover_open.png")!, UIImage(named: "update_1.png")!, UIImage(named: "update_2.png")!, UIImage(named: "update_3.png")!, UIImage(named: "cover_close.png")!]
    }
    
}
