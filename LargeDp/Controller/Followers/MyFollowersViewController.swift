//
//  MyFollowersViewController.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 13/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus
import GoogleMobileAds

class MyFollowersViewController: BaseViewController {
   
    // Mark: - Attributes -
    var myFollowersView : MyFollowersView!
    var isEmpty : Bool!
    // MARK: - Lifecycle -
    
    override init() {
        
        myFollowersView = MyFollowersView(frame:CGRect.zero)
        super.init(iView: myFollowersView, andNavigationTitle: AppName)
        isEmpty = true
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
    }
    
    init(isFollowers: Bool) {
        
        myFollowersView = MyFollowersView.init(isFollowers: isFollowers)
        if isFollowers == true
        {
             super.init(iView: myFollowersView, andNavigationTitle: "followers".localize())
        }
        else
        {
             super.init(iView: myFollowersView, andNavigationTitle: "followings".localize())
        }
        isEmpty = true
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
        
    }
    
    init(followeType : FolloweType, userProfileModel : UserProfileModel) {
        myFollowersView = MyFollowersView.init(followeType: followeType,userProfileModel: userProfileModel)
        
        switch followeType {
        case .followers:
            super.init(iView: myFollowersView, andNavigationTitle: "followers".localize())
            break
            
        case .following:
            super.init(iView: myFollowersView, andNavigationTitle: "followings".localize())
            break
        }
        isEmpty = false
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("MyFollowersViewController deinit called")
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if myFollowersView != nil && myFollowersView.superview != nil {
            myFollowersView.releaseObject()
            myFollowersView.removeFromSuperview()
            myFollowersView = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        if isEmpty == true
        {
            AppUtility.executeTaskInMainThreadAfterDelay(0.5, completion: { 
                self.myFollowersView.addBigNativeExpressAds()
            })
            
                        
        }
    }
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
       
        
        
      
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
        
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    @objc private func btnReloadTapped(sender : UIButton) {
        
        
       
    }
   
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -

}
