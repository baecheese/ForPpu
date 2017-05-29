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
    let empty = "No barcode number stored."
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
        
    }
    
    func setCardInfo() {
        orangeTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            orangeTitleLabel.text = ""
            orangeNumberLabel.text = Message().empty
            return;
        }
        orangeTitleLabel.text = sendDataBox.getCardInfo()?.0
        orangeNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if barCodeNumber == nil {
            orangeBarCodeImage.backgroundColor = .white
            orangeBarCodeImage.contentMode = .scaleAspectFit
            orangeBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            orangeBarCodeImage.contentMode = .scaleToFill
            orangeBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    @IBAction func goToAppFromOrange(_ sender: UITapGestureRecognizer) {
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
