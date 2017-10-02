//
//  AppDelegate.swift
//  ForPpu
//
//  Created by 배지영 on 2017. 5. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import Fabric
import Answers

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Answers.self])
        SharedMemoryContext.set(key: Key().screenBrightness, setValue: UIScreen.main.brightness)
        return true
    }

    let brightnessManager = ScreenBrightnessManager.sharedInstance
    
    func applicationWillResignActive(_ application: UIApplication) {
        if true == SharedMemoryContext.get(key: Key().isFullScreen) as? Bool {
            brightnessManager.goBackBeforeBrightness()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if true == SharedMemoryContext.get(key: Key().isFullScreen) as? Bool {
            brightnessManager.setFullScreenMode()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if true == VersoinManager.sharedInstance.checkUpdate() {
            saveNowBrightness()
            showFullScreenBarcode()
        }
        return true
    }
    
    let dataRepository = DataRepository.sharedInstance
    // modal로 한 번 올린 후에는 pop 이후에도 계속 재사용 (viewDidLoad 거치지 않음)
    let fullScreenBarcodeImageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
    
    func showFullScreenBarcode() {
        if nil != dataRepository.getSelectWidgetInfo() {
            if true != SharedMemoryContext.get(key: Key().isFullScreen) as? Bool {
                fullScreenBarcodeImageVC.modalPresentationStyle = .overCurrentContext
                self.window?.rootViewController?.present(fullScreenBarcodeImageVC, animated: true, completion: { () in
                    self.brightnessManager.setFullScreenMode()
                })
            }
            fullScreenBarcodeImageVC.changeBarcodeImage(cardInfo: dataRepository.getSelectWidgetInfo()!)
        }
    }
    
    func saveNowBrightness() {
        let beforeBrightness = (SharedMemoryContext.get(key: Key().screenBrightness)) as? CGFloat
        let nowBrightness = UIScreen.main.brightness
        if beforeBrightness != nowBrightness {
            SharedMemoryContext.set(key: Key().screenBrightness, setValue: nowBrightness)
        }
    }
    
}
