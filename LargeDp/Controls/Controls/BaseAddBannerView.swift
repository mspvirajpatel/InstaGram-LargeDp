//
//  BaseAddBannerView.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 05/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FirebaseAnalytics
import SwiftEventBus

class BaseAddBannerView: GADBannerView {
    
    // MARK: - Lifecycle -
    let bannerHeight : CGFloat = 50.0
    var constrainBannerHeight : NSLayoutConstraint!
    
    
    init(adSize: GADAdSize, bannerKey : String) {
        super.init(adSize: adSize)
        
        self.backgroundColor = Color.appPrimaryBG.withAlpha(0.2)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.adUnitID = bannerKey
        self.delegate = self
        
        self.setViewlayout()
        self.userBecomePremium()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(userBecomePremium(notification:)), name: Notification.Name(NotificationsName.userBecomePremium), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Interface -
    func setViewlayout() {
        constrainBannerHeight = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 1)
        self.addConstraint(constrainBannerHeight)
    }
    
    func requestBannerAd(rootController : UIViewController) {
        
        if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool {
            if !isPremium {
                self.rootViewController = rootController
                let request : GADRequest = GADRequest()
                //request.testDevices = [kGADSimulatorID]
                self.load(request)
            }
        }
        else
        {
            self.rootViewController = rootController
            let request : GADRequest = GADRequest()
            //request.testDevices = [kGADSimulatorID]
            self.load(request)
        }
    }
    
    func userBecomePremium(){
        SwiftEventBus.onMainThread(self, name: LocalNotification.inapppurchase) { [weak self] (notification) in
        if self == nil{
            return
        }
            self!.constrainBannerHeight.constant = 0
            UIView.animate(withDuration: 0.5) { [weak self] in
                if self == nil{
                    return
                }
                self!.layoutIfNeeded()
            }
        }
    }
    
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
}

extension BaseAddBannerView : GADBannerViewDelegate {
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        Analytics.logEvent("_click_home_add", parameters: [
            "" :"" as NSObject
            ])
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.constrainBannerHeight.constant = bannerHeight
        UIView.animate(withDuration: 0.5) { [weak self] in
            if self == nil{
                return
            }
            self?.layoutIfNeeded()
        }
    }
}
