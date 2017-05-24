//
//  FullScreenImageViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 24..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        barCodeImage = UIImageView(frame: commonFrame)
        barCodeImage.image = UIImage(named: "emptyImage.png")
        cell.addSubview(barCodeImage)
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
