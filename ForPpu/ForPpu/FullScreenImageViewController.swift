//
//  FullScreenImageViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 24..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    @IBOutlet var backView: UIView!
    @IBOutlet var fullImage: UIImageView!
    @IBOutlet var barcodeNumber: UILabel!
    
    let dataRepository = DataRepository.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFullImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setSharedContext()
    }
    
    private func setFullImage() {
        let cardInfo = dataRepository.getSelectWidgetInfo()
        changeBarcodeImage(cardInfo: cardInfo!)
        fullImage.contentMode = .scaleAspectFit
        if true != SharedMemoryContext.get(key: "isFullScreen") as? Bool {
            backView.transform = backView.transform.rotated(by: CGFloat(M_PI_2))
        }
    }
    
    func changeBarcodeImage(cardInfo:(String, String)) {
        let cardName = cardInfo.0
        let cardNumber = cardInfo.1
        fullImage.image = dataRepository.showBarCodeImage(cardNumber: cardNumber)
        barcodeNumber.text = cardName
    }
    
    private func setSharedContext() {
        SharedMemoryContext.set(key: "isFullScreen", setValue: true)
    }

    @IBAction func goBack(_ sender: UIButton) {
        dataRepository.deleteBeforeSelectCardInfo()
        SharedMemoryContext.set(key: "isFullScreen", setValue: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
