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
    
    func getInfoMenu() -> [String] {
        let infoMenu = InfoMenu()
        return [infoMenu.saveAndDelete, infoMenu.fullSize]
    }
    
    func getInfoImageList(info:Int) -> [UIImage] {
        if 0 == info {
            return [UIImage(named: "info.png")!, UIImage(named: "info.png")!]
        }
        return [UIImage(named: "info.png")!, UIImage(named: "info.png")!, UIImage(named: "info.png")!]
    }
    
}
