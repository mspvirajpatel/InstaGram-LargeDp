//
//  AppDelegate.swift
//  instalargedp
//
//  Created by VirajPatel on 26/05/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SwiftEventBus
import Firebase
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController : BaseNavigationController!
    //var sideMenuController : REFrostedViewController!
    var backgroundSessionCompletionHandler : (() -> Void)?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        try! DatabaseManager.sharedInstance.setUpDatabase(application)
        UIApplication.shared.statusBarStyle = .lightContent
        
//        GADMobileAds.configure(withApplicationID: ThiredPartyKey.adMob)
        LocationManager.shared.authorize()
        Crashlytics().debugMode = true
        Fabric.with([Crashlytics.self,Answers.self])
        
        #if DEBUG
            let isPremium = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser)
            if isPremium == nil
            {
                AppUtility.setUserDefaultsObject(false as AnyObject, forKey: UserDefaultKey.isPremiumUser)
                //SwiftEventBus.post("AdRemove", userInfo: [false : Bool()])
            }
        #else
            
        #endif
        
        AppUtility.setUserDefaultsObject(false as AnyObject, forKey: UserDefaultKey.isPremiumUser)
        
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        
        self.loadUI()
       
        // Override point for customization after application launch.
        return true
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
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    // MARK: Public Method
    open func loadUI(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.displayHome()
        window?.makeKeyAndVisible()
    }
    
    // MARK: Internal Helper
    private func displayHome() {
        
        let homeController : HomeController = HomeController()
        let menuController : SideMenuController = SideMenuController()
        
        navigationController = BaseNavigationController(rootViewController: homeController)
        
        let menuLeftNavigationController = UISideMenuNavigationController.init(rootViewController: menuController)
        
        menuLeftNavigationController.leftSide = false
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        //SideMenuManager.menuAddPanGestureToPresent(toView: navigationController.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigationController.view)
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.size.width), (UIScreen.main.bounds.size.height)) * 0.85), 240)
        
        SideMenuManager.default.menuAnimationFadeStrength = 0.50
        
        window?.rootViewController = navigationController
    }
}

