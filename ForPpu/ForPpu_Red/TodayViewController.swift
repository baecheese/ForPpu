//
//  TodayViewController.swift
//  ForPpu_Red
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
        
    @IBOutlet var redTitleLabel: UILabel!
    @IBOutlet var redBarCodeImage: UIImageView!
    @IBOutlet var redNumberLabel: UILabel!
    
    private let sendDataBox = SendDataBoxRed.sharedInstance
    
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
            emptyMessage.frame = redBarCodeImage.bounds
            emptyMessage.text = Message().empty
            emptyMessage.textColor = .black
            emptyMessage.textAlignment = .center
            emptyMessage.backgroundColor = .white
        }
    }
    
    func setCardInfo() {
        redTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            redTitleLabel.text = ""
            redNumberLabel.text = ""
            return;
        }
        redTitleLabel.text = sendDataBox.getCardInfo()?.0
        redNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if nil == barCodeNumber {
            redBarCodeImage.image = nil
        }
        else {
            redBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
        redBarCodeImage.addSubview(emptyMessage)
    }
    
    // ing 그룹에 저장되있는게 위젯으로 보이는 거랑 같은지 - 같으면 false / 다르면 change(true)
    func isChangeCardInfo() -> Bool {
        let widgetCardInfo = (redTitleLabel.text, redNumberLabel.text)
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
