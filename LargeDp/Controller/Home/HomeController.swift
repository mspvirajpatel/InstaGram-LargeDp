//
//  HomeController.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 20/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftEventBus

class HomeController: BaseViewController {

    // MARK: - Attributes -
    var homeView : HomeView!
    
    // MARK: - Lifecycle -
    
    override init()
    {
        homeView = HomeView.init()
        super.init(iView: homeView, andNavigationTitle: "search".localize())
        
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        homeView.btnSearchTapped { [weak self] (sender, object) in
            if self == nil {
                return
            }
            
            let searchViewController = SearchViewController.init(searchText: (object as? String)!)
            self?.navigationController?.pushViewController(searchViewController, animated: true)
        }
        AppUtility.executeTaskInMainThreadAfterDelay(0.5, completion: {
            self.homeView.viewAdd.requestBannerAd(rootController: self)
        })
        
        // Do any additional setup after loading the view.
    }
    
    deinit
    {
        print("Home controller Deinit Called")
        SwiftEventBus.unregister(self)
        NotificationCenter.default.removeObserver(self)
        
        if homeView != nil && homeView.superview != nil{
            homeView.releaseObject()
            homeView.removeFromSuperview()
            homeView = nil
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
    
}
