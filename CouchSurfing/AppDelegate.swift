//
//  AppDelegate.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/6.
//  Copyright © 2016年 monstar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,BMKGeneralDelegate{

    var window: UIWindow?
    var _mapManager: BMKMapManager?
    var mainNavigationController:NavigationController? = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        application.isStatusBarHidden = false
        IQKeyboardManager.sharedManager().enable = true
        
        setTintColor()
        
// MARK: - baidu Map Kit
        _mapManager = BMKMapManager()
        let ret = _mapManager?.start(KeyConstant.baiduMapKey, generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        
        let window:UIWindow = UIWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        self.window = window
        self.window?.makeKeyAndVisible()
        
// MARK: - root viewController
        self.setRootViewController()
        
        return true
    }
    
    func onGetNetworkState(_ iError: Int32) {
        if iError == 0 {
            print("联网成功")
        }else{
            print("onGetNetworkState \(iError)")
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if iError == 0 {
            print("授权成功")
        }else{
            print("onGetPermissionState \(iError)")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

//MARK: - func
extension AppDelegate{
    func setTintColor() {
        let navAppearance = UINavigationBar.appearance()
        navAppearance.tintColor = ScreenUI.mainColor
//        navAppearance.setBackgroundImage(UIImage.tint(color: ScreenUI.mainColor, blendMode: .normal, size: CGSize(width: 1, height: 1)), for: UIBarMetrics.default)
//        navAppearance.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navAppearance.backgroundColor = ScreenUI.mainColor
        navAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        let tabbarAppearance = UITabBar.appearance()
        tabbarAppearance.tintColor = UIColor.white
        tabbarAppearance.backgroundColor = ScreenUI.mainColor
        tabbarAppearance.backgroundImage = UIImage()
    }
    
   public func setRootViewController() {
        
        if UserDataManager.manager().guidancePageShow {
            
            if UserDataManager.manager().isLogin{
                let topC = TopTabBarController()
                let mainNaviC = NavigationController(rootViewController: topC)
                window?.rootViewController = mainNaviC
                mainNavigationController = mainNaviC
            }else{
                let loginC = LoginViewController()
                
                let mainNaviC = NavigationController(rootViewController: loginC)
                window?.rootViewController = mainNaviC
                mainNavigationController = mainNaviC
            }
        }else{
            let guidanceC:GuidancePageController = GuidancePageController()
            let mainNaviC = NavigationController(rootViewController: guidanceC)
            guidanceC.toucheBlock = {
                let loginC = LoginViewController()
            
                self.mainNavigationController?.pushViewController(loginC, animated: true)
            }
            window?.rootViewController = mainNaviC
            mainNavigationController = mainNaviC
        }
    }
    
    static public let appDelegate = UIApplication.shared.delegate as! AppDelegate
}
