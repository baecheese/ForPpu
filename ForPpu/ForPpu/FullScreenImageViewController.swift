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
    
    func setFullImage() {
        let barcode = SharedMemoryContext.get(key: Key().barcodeNumber) as? String
        if true == barcode?.isEmpty {
            fullImage.image = UIImage(named: "emptyImage.png")
            barcodeNumber.text = "바코드 넘버가 업습니다."
        }
        else {
            fullImage.image = dataRepository.showBarCodeImage(cardNumber: barcode!)
            barcodeNumber.text = barcode
        }
        fullImage.contentMode = .scaleAspectFit
        
        backView.transform = backView.transform.rotated(by: CGFloat(M_PI_2))
    }
    

    @IBAction func goBack(_ sender: UIButton) {
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
