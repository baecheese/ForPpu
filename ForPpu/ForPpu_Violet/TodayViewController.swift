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
    let empty = "No barcode number stored."
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
    }
    
    func setCardInfo() {
        violetTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            violetTitleLabel.text = ""
            violetNumberLabel.text = Message().empty
            return;
        }
        violetTitleLabel.text = sendDataBox.getCardInfo()?.0
        violetNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if barCodeNumber == nil {
            violetBarCodeImage.backgroundColor = .white
            violetBarCodeImage.contentMode = .scaleAspectFit
            violetBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            violetBarCodeImage.contentMode = .scaleToFill
            violetBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    @IBAction func goToAppFromViolet(_ sender: UITapGestureRecognizer) {
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
