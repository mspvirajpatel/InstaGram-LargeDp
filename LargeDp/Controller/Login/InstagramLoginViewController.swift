//
//  LoginViewController.swift
//  InstaLargerDp
//
//  Created by Viraj Patel on 08/12/16.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftEventBus

class InstagramLoginViewController:BaseViewController{
    
    // MARK :- Attributes -
    
    var loginView : InstagramLoginView!
    
    // MARK :- Life Cycle -
    
    override init()
    {
        let  subView : InstagramLoginView = InstagramLoginView(frame:CGRect.zero)
        super.init(iView: subView, andNavigationTitle: "login".localize())
        
        loginView = subView
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
   
    deinit
    {
        print("Login controller Deinit Called")
        NotificationCenter.default.removeObserver(self)
        
        if loginView != nil && loginView.superview != nil{
            loginView.removeFromSuperview()
            loginView = nil
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var btnDismiss : UIButton! = UIButton(type: .custom)
        btnDismiss.setImage(UIImage(named: "closed")?.maskWithColor(.white), for: .normal)
        btnDismiss.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        btnDismiss.imageEdgeInsets = SystemConstants.IS_IPAD ? UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5 ) : UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        btnDismiss.addTarget(self, action: #selector(self.btnDismissTapped(sender:)), for: .touchUpInside)
        var buttonItemDismiss : UIBarButtonItem! = UIBarButtonItem(customView: btnDismiss)
        
        self.navigationItem.setRightBarButtonItems([buttonItemDismiss], animated: true)
        
      
        defer {
            btnDismiss = nil
            buttonItemDismiss = nil
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @objc private func btnDismissTapped(sender : UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    // MARK : - Layout -
    
    override func loadViewControls() {
        
        super.loadViewControls()
        
        loginView.loginEvent { [weak self] (success, object) in
            if self == nil{
                return
            }
            SwiftEventBus.post(LocalNotification.loginEvent, sender: self)
            self?.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    override func setViewlayout() {
        
        super.setViewlayout()
        super.expandViewInsideView()
    }
}
