//
//  InfoDetailViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 6. 5..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var background: UIScrollView!
    
    let infoManager = InfoManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        setInfoDetailImage(info: SharedMemoryContext.get(key: Key().info) as! Int)
    }
    
    func setInfoDetailImage(info:Int) {
        let imageList = infoManager.getInfoImageList(info: info)
        let imageCount = imageList.count
        setContentsSize(imageCount: imageCount)
        var offsetX:CGFloat = 0.0
        for image in imageList {
            let infoImage = UIImageView(frame: CGRect(x: offsetX, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            infoImage.image = image
            infoImage.contentMode = .scaleAspectFit
            background.addSubview(infoImage)
            offsetX += self.view.frame.width
        }
    }
    
    private func setContentsSize(imageCount:Int) {
        self.automaticallyAdjustsScrollViewInsets = false;
        background.contentInset = .zero
        background.scrollIndicatorInsets = .zero
        background.contentOffset = CGPoint(x: 0, y: 0)
        background.isPagingEnabled = true
        background.contentSize = CGSize(width: view.frame.width * CGFloat(imageCount), height: background.frame.height)
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
