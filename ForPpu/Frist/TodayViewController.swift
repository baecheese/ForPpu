//
//  TodayViewController.swift
//  Frist
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

/** 위젯에 넘기는 용으로 쓰는 것 */
struct GroupKeys {
    let suiteName = "group.com.baecheese.ForPpu"
    let cardID = "cardID"
    let cardName = "cardName"
    let cardNumber = "cardNumber"
    let image = "barCodeImage"
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let userDefault = UserDefaults(suiteName: GroupKeys().suiteName)
    
    @IBOutlet var FristTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let test = userDefault?.value(forKey: "test") as! String
        FristTitle.text = String(describing: test)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
