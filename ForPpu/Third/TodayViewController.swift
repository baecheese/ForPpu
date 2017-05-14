//
//  TodayViewController.swift
//  Third
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private let sendDataBox = SendDataBoxThree.sharedInstance
    
    @IBOutlet var thirdTitleLabel: UILabel!
    @IBOutlet var thirdImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCardInfo()
        setBarCodeImage()
    }
    
    func setCardInfo() {
        if nil == sendDataBox.getCardInfo() {
            thirdTitleLabel.text = "저장된 카드가 없습니다."
            return;
        }
        let info = "\(String(describing: (sendDataBox.getCardInfo()?.0)!))"
        thirdTitleLabel.text = info
    }
    
    
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if true == barCodeNumber?.isEmpty {
            thirdImage.image = nil
        }
        else {
            thirdImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
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
