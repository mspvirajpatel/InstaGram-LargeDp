//
//  NotificationManager.swift
//  ViewControllerDemo
//
//  Created by SamSol on 09/08/16.
//  Copyright © 2016 SamSol. All rights reserved.
//

import Foundation
import SystemConfiguration
import UserNotifications
import ReachabilitySwift
import SwiftEventBus

struct PushNotificationType : OptionSet {
    
    let rawValue: Int
    
    static let InvalidNotificationType = PushNotificationType(rawValue: -1)
    static let HomeNotificationType = PushNotificationType(rawValue: 1)
    static let OtherNotificationType = PushNotificationType(rawValue: 2)
    
}

open class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - Attributes -
    
    var KReloadKeyboard:String = "KReloadKeyboard"
    var KSuccessGoogleLogin:String = "KSuccessGoogleLogin"
    var KunSuccessGoogleLogin:String = "KunSuccessGoogleLogin"
 
   // MARK: - Lifecycle -
    
    static let sharedInstance : NotificationManager = {
        
        let instance = NotificationManager()
        return instance
        
    }()
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
    }
    
    // MARK: - Public Interface -
    
    open func isNetworkAvailableWithBlock(_ completion: @escaping (_ wasSuccessful: Bool) -> Void) {
      
        let reachability = Reachability()!
        
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                completion(true)
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
                completion(false)
            }
            
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
            completion(false)
        }
     
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
//                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
//            }
//        }
//        
//        var flags = SCNetworkReachabilityFlags()
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
//            completion(false)
//        }
//        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
//        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
//        completion(isReachable && !needsConnection )
        
    }
    
    
    // MARK: - Internal Helpers -

    open func reloadKeyboard(_ isSet: Bool) {
        
        var userInfo: [String: Bool]? = nil
        
        userInfo = ["user": isSet]
        
        let notification = Notification.init(name: Notification.Name(rawValue: KReloadKeyboard), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    open func profileApiCall(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["TimeLineUser": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: NotificationsName.ProfileAPICall), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    open func timelinePaggination(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["timeline": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: NotificationsName.TimeLinePaggination), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    open func trackerHastagPaggination(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["TagDetails": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: NotificationsName.TrackerHastagPaggination), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    open func trackerUserMediaPaggination(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["PaginationMedia": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: NotificationsName.TrackerUserMediaPaggination), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    
    open func userMediaPaggination(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["UserMedia": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: NotificationsName.LoginUserMediaPaggination), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    open func searchUserMediaPaggination(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["SearchUserMedia": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: NotificationsName.SearchUserMediaPaggination), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    open func hastagPaggination(_ anydata: AnyObject) {
        
        var userInfo: [String: AnyObject]? = nil
        
        userInfo = ["HastagDetails": anydata]
        
        let notification = Notification.init(name: Notification.Name(rawValue: NotificationsName.HastagPaggination), object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
        
    }
    
    
    func handlePushNotification(_ userInfo: [AnyHashable: Any]) {
       
        
    }
 
    
    
//    In case if you need to know the permissions granted
//    
//    UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
//    
//    switch setttings.soundSetting{
//    case .enabled:
//    
//    print("enabled sound setting")
//    
//    case .disabled:
//    
//    print("setting has been disabled")
//    
//    case .notSupported:
//    print("something vital went wrong here")
//    }
//    }
    
}
