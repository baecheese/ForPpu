//
//  TodayViewController.swift
//  ForPpu_Red
//
//  Created by 배지영 on 2017. 5. 16..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

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
    }
    
    var emptyMessage = UILabel()
    
    func setEmptyInfo() {
        if nil == sendDataBox.getCardInfo() {
            emptyMessage.frame = redBarCodeImage.bounds
            emptyMessage.text = "저장된 바코드가 없습니다."
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
        if true == barCodeNumber?.isEmpty || barCodeNumber == nil {
            redBarCodeImage.image = nil
        }
        else {
            redBarCodeImage.image = sendDataBox.showBarCode(cardNumber: barCodeNumber!)
        }
        redBarCodeImage.addSubview(emptyMessage)
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
