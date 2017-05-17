//
//  TodayViewController.swift
//  ForPpu_Yellow
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
    
    @IBOutlet var yellowTitleLabel: UILabel!
    @IBOutlet var yellowBarCodeImage: UIImageView!
    @IBOutlet var yellowNumberLabel: UILabel!
    
    private let sendDataBox = SendDataBoxYellow.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCardInfo()
        setBarCodeImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setCardInfo() {
        yellowTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            yellowTitleLabel.text = ""
            yellowNumberLabel.text = Message().empty
            return;
        }
        yellowTitleLabel.text = sendDataBox.getCardInfo()?.0
        yellowNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if barCodeNumber == nil {
            yellowBarCodeImage.backgroundColor = .white
            yellowBarCodeImage.contentMode = .scaleAspectFit
            yellowBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            yellowBarCodeImage.contentMode = .scaleToFill
            yellowBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    func isChangeCardInfo() -> Bool {
        let widgetCardInfo = (yellowTitleLabel.text, yellowNumberLabel.text)
        let newCardInfo = sendDataBox.getCardInfo()
        
        if widgetCardInfo.0 == newCardInfo?.0 || widgetCardInfo.1 == newCardInfo?.1 || true == isEmptyInGroupDefaultAndWidget() {
            return false
        }
        return true
    }
    
    func isEmptyInGroupDefaultAndWidget() -> Bool {
        let newCardInfo = sendDataBox.getCardInfo()
        if yellowNumberLabel.text == Message().empty && newCardInfo == nil {
            return true
        }
        return false
    }
    
    @IBAction func goToAppFromYellow(_ sender: UITapGestureRecognizer) {
        extensionContext?.open(URL(string: "forPpu://")! , completionHandler: nil)
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
