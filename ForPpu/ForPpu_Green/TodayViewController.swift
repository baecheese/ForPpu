//
//  TodayViewController.swift
//  ForPpu_Green
//
//  Created by 배지영 on 2017. 5. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

struct Message {
    let empty = "No barcode number stored."
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var greenTitleLabel: UILabel!
    @IBOutlet var greenBarCodeImage: UIImageView!
    @IBOutlet var greenNumberLabel: UILabel!
    
    let doubleTap = UITapGestureRecognizer()
    
    private let sendDataBox = SendDataBoxGreen.sharedInstance
    
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
        greenTitleLabel.backgroundColor = sendDataBox.getMainColor()
        let cardInfo = sendDataBox.getCardInfo()
        if nil == sendDataBox.getCardInfo() {
            greenTitleLabel.text = ""
            greenNumberLabel.text = Message().empty
        }
        else {
            greenTitleLabel.text = cardInfo?.0
            greenNumberLabel.text = cardInfo?.1
            if true == cardInfo?.1.isEmpty {
                greenNumberLabel.text = Message().empty
            }
        }
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if true == barCodeNumber?.isEmpty || nil == barCodeNumber {
            greenBarCodeImage.backgroundColor = .white
            greenBarCodeImage.contentMode = .scaleAspectFit
            greenBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            greenBarCodeImage.contentMode = .scaleToFill
            greenBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    func setDoubleTap() {
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(TodayViewController.goToAppFromGreen))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(doubleTap)
    }
    
    func goToAppFromGreen() {
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
