//
//  TodayViewController.swift
//  ForPpu_Blue
//
//  Created by 배지영 on 2017. 5. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

struct Message {
    let empty = "저장된 바코드가 없습니다."
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var blueTitleLabel: UILabel!
    @IBOutlet var blueBarCodeImage: UIImageView!
    @IBOutlet var blueNumberLabel: UILabel!
    
    private let sendDataBox = SendDataBoxBlue.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCardInfo()
        setBarCodeImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setCardInfo() {
        blueTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            blueTitleLabel.text = ""
            blueNumberLabel.text = Message().empty
            return;
        }
        blueTitleLabel.text = sendDataBox.getCardInfo()?.0
        blueNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if barCodeNumber == nil {
            blueBarCodeImage.backgroundColor = .white
            blueBarCodeImage.contentMode = .scaleAspectFit
            blueBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            blueBarCodeImage.contentMode = .scaleToFill
            blueBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    func isChangeCardInfo() -> Bool {
        let widgetCardInfo = (blueTitleLabel.text, blueNumberLabel.text)
        let newCardInfo = sendDataBox.getCardInfo()
        
        if widgetCardInfo.0 == newCardInfo?.0 || widgetCardInfo.1 == newCardInfo?.1 || true == isEmptyInGroupDefaultAndWidget() {
            return false
        }
        return true
    }
    
    func isEmptyInGroupDefaultAndWidget() -> Bool {
        let newCardInfo = sendDataBox.getCardInfo()
        if blueNumberLabel.text == Message().empty && newCardInfo == nil {
            return true
        }
        return false
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
