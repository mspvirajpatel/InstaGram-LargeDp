//
//  PeopleListViewController.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 13/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//


import UIKit
import SwiftEventBus
import GRDB

class MyFavouriteViewController: BaseViewController {
   
    // Mark: - Attributes -
    var myFavouriteListView : MyFavouriteListView!
    var isRequested : Bool = false
    
    // MARK: - Lifecycle -
    
    override init() {
        
        myFavouriteListView = MyFavouriteListView(frame:CGRect.zero)
        super.init(iView: myFavouriteListView, andNavigationTitle: "myCollection".localize())
        
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
        
        if myFavouriteListView != nil && myFavouriteListView.superview != nil {
            myFavouriteListView.releaseObject()
            myFavouriteListView.removeFromSuperview()
            myFavouriteListView = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.refreshModelfromDatabase()
    }
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
      
        SwiftEventBus.onMainThread(self, name:"reloadCollection") {[weak self] result in
            
            if self == nil{
                return
            }
            
            self!.refreshModelfromDatabase()
           
        }
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
        
    }
    
  
    // MARK: - Public Interface -
   
    func refreshModelfromDatabase() {
        if !isRequested {
            AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                if self == nil {
                    return
                }
                
                if self?.myFavouriteListView != nil{
                    self?.myFavouriteListView.showProgressHUD(viewController: self!.myFavouriteListView, title: nil, subtitle: nil)
                    self?.isRequested = true
                }
            }
            AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in
                if self == nil {
                    return
                }
                
                do
                {
                    try DatabaseManager.sharedInstance.getMyFavourite(completion: { [weak self] (arrModel) in
                        if self == nil {
                            return
                        }
                        let anyobjecvt : [AnyObject] = arrModel
                        
                        self!.myFavouriteListView.anyobject = NSMutableArray(array: anyobjecvt)
                        
                        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                            if self == nil {
                                return
                            }
                            if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool
                            {
                                if !isPremium
                                {
                                   self!.myFavouriteListView.addNativeExpressAds()
                                }
                            }
                            
                            self!.myFavouriteListView.tableView.reloadData()
                            self!.myFavouriteListView.hideProgressHUD()
                            self!.isRequested = false
                        }
                        
                    })
                    
                }
                catch let error as NSError {
                    print(error.description)
                }
            }
        }
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -

}
