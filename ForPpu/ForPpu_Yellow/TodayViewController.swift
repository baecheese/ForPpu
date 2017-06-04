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
    let empty = "No barcode number stored."
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var yellowTitleLabel: UILabel!
    @IBOutlet var yellowBarCodeImage: UIImageView!
    @IBOutlet var yellowNumberLabel: UILabel!
    
    let doubleTap = UITapGestureRecognizer()
    
    private let sendDataBox = SendDataBoxYellow.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCardInfo()
        setBarCodeImage()
        setDoubleTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setCardInfo() {
        yellowTitleLabel.backgroundColor = sendDataBox.getMainColor()
        let cardInfo = sendDataBox.getCardInfo()
        if nil == cardInfo {
            yellowTitleLabel.text = ""
            yellowNumberLabel.text = Message().empty
        }
        else {
            yellowTitleLabel.text = cardInfo?.0
            yellowNumberLabel.text = cardInfo?.1
            if true == cardInfo?.1.isEmpty {
                yellowNumberLabel.text = Message().empty
            }
        }
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if true == barCodeNumber?.isEmpty || nil == barCodeNumber {
            yellowBarCodeImage.backgroundColor = .white
            yellowBarCodeImage.contentMode = .scaleAspectFit
            yellowBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            yellowBarCodeImage.contentMode = .scaleToFill
            yellowBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    func setDoubleTap() {
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(TodayViewController.goToAppFromYellow))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(doubleTap)
    }
    
    func goToAppFromYellow() {
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
