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
    
    @IBOutlet var page: UILabel!
    private var totalPage = ""
    let infoManager = InfoManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.delegate = self
        setScrollMargen()
        setNavigationBar(info: SharedMemoryContext.get(key: Key().info) as! Int)
        setPageText(info: SharedMemoryContext.get(key: Key().info) as! Int)
    }
    
    override func viewWillLayoutSubviews() {
        setInfoDetailImage(info: SharedMemoryContext.get(key: Key().info) as! Int)
        setCloseButton()
    }
    
    func setScrollMargen() {
        self.automaticallyAdjustsScrollViewInsets = false
        background.contentInset = .zero
        background.scrollIndicatorInsets = .zero
        background.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func setNavigationBar(info:Int) {
        if infoManager.updateInfo == info {
            let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
            navigationItem.leftBarButtonItem = backButton
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    func setInfoDetailImage(info:Int) {
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
        let imageHeight = view.frame.height * 0.8
        let infoImage = UIImageView(frame: CGRect(x: offsetX, y: 0, width: view.frame.width, height: imageHeight))
        infoImage.image = image
        infoImage.contentMode = .scaleAspectFit
        background.addSubview(infoImage)
    }
    
    private func setContentsSize(imageCount:Int) {
        background.isPagingEnabled = true
        let imageHeight = view.frame.height * 0.8
        background.contentSize = CGSize(width: view.frame.width * CGFloat(imageCount), height: imageHeight)
    }
    
    private func setCloseButton() {
        if infoManager.updateInfo == SharedMemoryContext.get(key: Key().info) as! Int {
            
            let viewWidth = view.frame.width
            let count = CGFloat((infoManager.getInfoImageList(info: infoManager.updateInfo).count))
            let imageHeight = view.frame.height * 0.8
            
            let margen:CGFloat = 30.0
            let buttonWidth:CGFloat = 100.0
            let buttonHeight:CGFloat = 40.0
            
            let offsetX = viewWidth*count - (viewWidth/2) - (buttonWidth/2)
            let offsetY = imageHeight - buttonHeight - margen
            let close = UIButton(frame: CGRect(x: offsetX, y: offsetY, width: buttonWidth, height: buttonHeight))
            close.setImage(UIImage(named: "close_icon.png"), for: .normal)
            close.addTarget(self, action: #selector(InfoDetailViewController.clickClose), for: .touchUpInside)
            background.addSubview(close)
        }
    }
    
    @objc func clickClose() {
        VersoinManager.sharedInstance.setCheckUpdate()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func setPageText(info:Int) {
        totalPage = "\(infoManager.getInfoImageList(info: info).count)"
        page.text = "1 / \(totalPage)"
    }
    
    var beforeIndex = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentX = scrollView.contentOffset.x
        let width = view.frame.width
        let nowIndex = Int(currentX / width)
        if beforeIndex != nowIndex {
            beforeIndex = nowIndex
            changePageNumber(nowPage: nowIndex + 1)
        }
    }
    
    func changePageNumber(nowPage:Int) {
        page.text = "\(nowPage) / \(totalPage)"
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
