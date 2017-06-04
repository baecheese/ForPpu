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
    let empty = "No barcode number stored."
}

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var redTitleLabel: UILabel!
    @IBOutlet var redBarCodeImage: UIImageView!
    @IBOutlet var redNumberLabel: UILabel!
    
    let doubleTap = UITapGestureRecognizer()
    
    private let sendDataBox = SendDataBoxRed.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCardInfo()
        setBarCodeImage()
        setDoubleTap()
    }
    
    func setCardInfo() {
        redTitleLabel.backgroundColor = sendDataBox.getMainColor()
        let cardInfo = sendDataBox.getCardInfo()
        if nil == cardInfo {
            redTitleLabel.text = ""
            redNumberLabel.text = Message().empty
        }
        else {
            redTitleLabel.text = cardInfo?.0
            redNumberLabel.text = cardInfo?.1
            if true == cardInfo?.1.isEmpty {
                redNumberLabel.text = Message().empty
            }
        }
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if true == barCodeNumber?.isEmpty || nil == barCodeNumber {
            redBarCodeImage.backgroundColor = .white
            redBarCodeImage.contentMode = .scaleAspectFit
            redBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            redBarCodeImage.contentMode = .scaleToFill
            redBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    func setDoubleTap() {
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(TodayViewController.goToAppFromRed))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(doubleTap)
    }
    
    func goToAppFromRed() {
        sendDataBox.setSelectBarcode()
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
