//
//  TodayViewController.swift
//  ForPpu_Orange
//
//  Created by 배지영 on 2017. 5. 16..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

struct Message {
    let empty = "저장된 바코드가 없습니다."
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var orangeTitleLabel: UILabel!
    @IBOutlet var orangeBarCodeImage: UIImageView!
    @IBOutlet var orangeNumberLabel: UILabel!
    
    private let sendDataBox = SendDataBoxOrange.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCardInfo()
        setBarCodeImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setEmptyInfo()
        if true == isChangeCardInfo() {
            setCardInfo()
            setBarCodeImage()
        }
    }
    
    var emptyMessage = UILabel()
    
    func setEmptyInfo() {
        if nil == sendDataBox.getCardInfo() && Message().empty == emptyMessage.text {
            emptyMessage.frame = orangeBarCodeImage.bounds
            emptyMessage.text = Message().empty
            emptyMessage.textColor = .black
            emptyMessage.textAlignment = .center
            emptyMessage.backgroundColor = .white
        }
    }
    
    func setCardInfo() {
        orangeTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            orangeTitleLabel.text = ""
            orangeNumberLabel.text = ""
            return;
        }
        orangeTitleLabel.text = sendDataBox.getCardInfo()?.0
        orangeNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if barCodeNumber == nil {
            orangeBarCodeImage.image = nil
        }
        else {
            orangeBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
        orangeBarCodeImage.addSubview(emptyMessage)
    }
    
    func isChangeCardInfo() -> Bool {
        let widgetCardInfo = (orangeTitleLabel.text, orangeNumberLabel.text)
        let newCardInfo = sendDataBox.getCardInfo()
        
        if widgetCardInfo.0 == newCardInfo?.0 || widgetCardInfo.1 == newCardInfo?.1 || true == isEmptyInGroupDefaultAndWidget() {
            return false
        }
        return true
    }
    
    func isEmptyInGroupDefaultAndWidget() -> Bool {
        let newCardInfo = sendDataBox.getCardInfo()
        if emptyMessage.text == Message().empty && newCardInfo == nil {
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
