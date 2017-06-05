//
//  InfoDetailViewController.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 6. 5..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class InfoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var backView: UIView!
    @IBOutlet var background: UIScrollView!
    
    let infoManager = InfoManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.delegate = self
        setNavigationBar(info: SharedMemoryContext.get(key: Key().info) as! Int)
    }
    
    override func viewWillLayoutSubviews() {
        setInfoDetailImage(info: SharedMemoryContext.get(key: Key().info) as! Int)
        setCloseButton()
    }
    
    func setNavigationBar(info:Int) {
        if infoManager.updateInfo == info {
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    func setInfoDetailImage(info:Int) {
        
        self.automaticallyAdjustsScrollViewInsets = false
        background.contentInset = .zero
        background.scrollIndicatorInsets = .zero
        
        let imageList = infoManager.getInfoImageList(info: info)
        let imageCount = imageList.count
        setContentsSize(imageCount: imageCount)
        var offsetX:CGFloat = 0.0
        for infoImage in imageList {
            setInfoImage(info: info, image: infoImage, offsetX: offsetX)
            offsetX += self.view.frame.width
        }
    }
    
    func setInfoImage(info:Int, image:UIImage, offsetX:CGFloat) {
        let infoImage = UIImageView(frame: CGRect(x: offsetX, y: 0, width: backView.frame.width, height: backView.frame.height))
        infoImage.image = image
        infoImage.contentMode = .scaleAspectFit
        infoImage.backgroundColor = .red
        background.addSubview(infoImage)
    }
    
    private func setContentsSize(imageCount:Int) {
        background.isPagingEnabled = true
        background.contentSize = CGSize(width: backView.frame.width * CGFloat(imageCount), height: backView.frame.height)
    }
    
    private func setCloseButton() {
        if infoManager.updateInfo == SharedMemoryContext.get(key: Key().info) as! Int {
            let offsetX = view.frame.width * CGFloat(infoManager.getInfoImageList(info: infoManager.updateInfo).count-1)
            let close = UIButton()
            close.frame.size = view.frame.size
            close.frame.origin = CGPoint(x: offsetX, y: 0)
            close.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            close.addTarget(self, action: #selector(InfoDetailViewController.clickClose), for: .touchUpInside)
            background.addSubview(close)
        }
    }
    
    func clickClose() {
        VersoinManager.sharedInstance.setCheckUpdate()
        self.navigationController?.popViewController(animated: true)
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
