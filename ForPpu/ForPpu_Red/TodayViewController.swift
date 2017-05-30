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
    
    private let sendDataBox = SendDataBoxRed.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setCardInfo()
        setBarCodeImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
    }
    
    override func viewDidLayoutSubviews() {
        setFullScreenButton()
    }
    
    func setCardInfo() {
        redTitleLabel.backgroundColor = sendDataBox.getMainColor()
        if nil == sendDataBox.getCardInfo() {
            redTitleLabel.text = ""
            redNumberLabel.text = Message().empty
            return;
        }
        redTitleLabel.text = sendDataBox.getCardInfo()?.0
        redNumberLabel.text = sendDataBox.getCardInfo()?.1
    }
    
    func setBarCodeImage() {
        let barCodeNumber = sendDataBox.getCardInfo()?.1
        if nil == barCodeNumber {
            redBarCodeImage.backgroundColor = .white
            redBarCodeImage.contentMode = .scaleAspectFit
            redBarCodeImage.image = UIImage(named: "emptyImage.png")
        }
        else {
            redBarCodeImage.contentMode = .scaleToFill
            redBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
    }
    
    @IBAction func goToAppFromRed(_ sender: UITapGestureRecognizer) {
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
    
    func setFullScreenButton() {
        let buttonSize:CGFloat = 30
        let fullScreen = UIButton(frame: CGRect(x: redNumberLabel.frame.width - buttonSize, y: redNumberLabel.frame.height - buttonSize, width: buttonSize, height: buttonSize))
        fullScreen.setImage(UIImage(named: "fullscreen.png"), for: .normal)
        redNumberLabel.addSubview(fullScreen)
    }
    
}
