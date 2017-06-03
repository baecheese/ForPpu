//
//  TodayViewController.swift
//  ForPpu_Indigo
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
    
    @IBOutlet var indigoTitleLabel: UILabel!
    @IBOutlet var indigoBarCodeImage: UIImageView!
    @IBOutlet var indigoNumberLabel: UILabel!
    
    let doubleTap = UITapGestureRecognizer()
    
    private let sendDataBox = SendDataBoxIndigo.sharedInstance
    
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
        indigoTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            indigoTitleLabel.text = ""
            indigoNumberLabel.text = Message().empty
            return;
        }
        indigoTitleLabel.text = sendDataBox.getCardInfo()?.0
        indigoNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if barCodeNumber == nil {
            indigoBarCodeImage.backgroundColor = .white
            indigoBarCodeImage.contentMode = .scaleAspectFit
            indigoBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            indigoBarCodeImage.contentMode = .scaleToFill
            indigoBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    func setDoubleTap() {
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(TodayViewController.goToAppFromIndigo))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(doubleTap)
    }
    
    func goToAppFromIndigo() {
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
