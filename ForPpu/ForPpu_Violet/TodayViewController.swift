//
//  TodayViewController.swift
//  ForPpu_Violet
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
    
    @IBOutlet var violetTitleLabel: UILabel!
    @IBOutlet var violetBarCodeImage: UIImageView!
    @IBOutlet var violetNumberLabel: UILabel!
    
    private let sendDataBox = SendDataBoxViolet.sharedInstance
    
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
        if nil == sendDataBox.getCardInfo() && Message().empty != emptyMessage.text {
            emptyMessage.frame = violetBarCodeImage.bounds
            emptyMessage.text = Message().empty
            emptyMessage.textColor = .black
            emptyMessage.textAlignment = .center
            emptyMessage.backgroundColor = .white
        }
    }
    
    func setCardInfo() {
        violetTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            violetTitleLabel.text = ""
            violetNumberLabel.text = ""
            return;
        }
        violetTitleLabel.text = sendDataBox.getCardInfo()?.0
        violetNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if barCodeNumber == nil {
            violetBarCodeImage.image = nil
        }
        else {
            violetBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
        violetBarCodeImage.addSubview(emptyMessage)
    }
    
    func isChangeCardInfo() -> Bool {
        let widgetCardInfo = (violetTitleLabel.text, violetNumberLabel.text)
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
