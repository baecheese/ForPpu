//
//  TodayViewController.swift
//  ForPpu_Blue
//
//  Created by 배지영 on 2017. 5. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

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
        setEmptyInfo()
    }
    
    func setEmptyInfo() {
        if nil == sendDataBox.getCardInfo() {
            let emptyMessage = UILabel(frame: blueBarCodeImage.bounds)
            emptyMessage.text = "저장된 바코드가 없습니다."
            emptyMessage.textColor = .black
            emptyMessage.textAlignment = .center
            emptyMessage.backgroundColor = .white
            blueBarCodeImage.addSubview(emptyMessage)
        }
    }
    
    func setCardInfo() {
        if nil == sendDataBox.getCardInfo() {
            blueTitleLabel.text = ""
            blueNumberLabel.text = ""
            return;
        }
        blueTitleLabel.text = sendDataBox.getCardInfo()?.0
        blueTitleLabel.backgroundColor = sendDataBox.getMainColor()
        blueNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if true == barCodeNumber?.isEmpty || barCodeNumber == nil {
            blueBarCodeImage.image = nil
        }
        else {
            blueBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
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
