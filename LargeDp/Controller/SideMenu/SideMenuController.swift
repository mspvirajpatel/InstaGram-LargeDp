//
//  SideMenuController.swift
//  InstaLargerDp
//
//  Created by WebMob on 20/04/17.
//  Copyright © 2017 WebMobTech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftEventBus
import SideMenu

class SideMenuController: BaseViewController {
    
    // MARK: - Attributes -
    var sideMenuView : SideMenuView!
    var currentSelectedMenu : Int = Menu.home.rawValue
    var followersView : MyFollowersViewController!
    var followingsView : MyFollowersViewController!
    
    // MARK: - Lifecycle -
    override init()
    {
        sideMenuView = SideMenuView()
        super.init(iView: sideMenuView, andNavigationTitle: "")
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder:aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
//        if sideMenuView != nil{
//            sideMenuView.loadMenuData()
//        }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.sideMenuView != nil{
            self.sideMenuView.updateUI()
        }
    }
    
    deinit{
        SwiftEventBus.unregister(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        //self.displaySelectedView(type: currentSelectedMenu)
        
        sideMenuView.cellSelectedEvent { [weak self] (sendor, object) in
            if self == nil{
                return
            }
            self!.displaySelectedView(type: object as! Int)
        }
        
        SwiftEventBus.onMainThread(self, name: LocalNotification.loginEvent) { [weak self] (notification) in
            if self == nil{
                return
            }
          
            self!.displaySelectedView(type: Menu.home.rawValue)
        }
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    // MARK: - Public Interface -
    // MARK: - User Interaction -
    // MARK: - Internal Helpers -
    
    
    private func displaySelectedView(type : Int)
    {
        
        if currentSelectedMenu != type || type == Menu.logout.rawValue {
            var controller : BaseViewController? = self.setSelectedMenuObject(menuType: type)
            
            if controller != nil{
                if type == Menu.login.rawValue
                {
                    let navController : BaseNavigationController! = BaseNavigationController(rootViewController: controller!)
                
                    SideMenuManager.menuLeftNavigationController?.present(navController, animated: true, completion: {
                    
                    })
                    
                }
                else{
                    AppUtility.executeTaskInMainQueueWithCompletion {
                        
                        self.dismiss(animated: true, completion: { 
                            
                        })
                        
//                        (SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
                        
                    }
                    
                    AppUtility.getAppDelegate().navigationController.viewControllers = [controller!]
                    
                }
            }
            
            if type != Menu.logout.rawValue
            {
                if type != Menu.login.rawValue
                {
                    AppUtility.executeTaskInMainQueueWithCompletion {
                        self.dismiss(animated: true, completion: {
                            
                        })
                        
                    }
                    
                }
                
            }
            
            defer {
                controller = nil
            }
        }
        else{
            if type == Menu.login.rawValue
            {
                var controller : BaseViewController? = self.setSelectedMenuObject(menuType: type)
                
                if controller != nil{
                    if type == Menu.login.rawValue
                    {
                       
                        let navController : BaseNavigationController! = BaseNavigationController(rootViewController: controller!)
                        
                        SideMenuManager.menuLeftNavigationController?.present(navController, animated: true, completion: {
                            
                        })
                        //currentSelectedMenu = Menu.login.rawValue
                        
                    }
                    else{
                        AppUtility.executeTaskInMainQueueWithCompletion {
                            self.dismiss(animated: true, completion: {
                                
                            })

                        }
                    }
                }
                
                defer {
                    controller = nil
                }
            }
            else{
                AppUtility.executeTaskInMainQueueWithCompletion {
                    self.dismiss(animated: true, completion: {
                        
                    })
                    
                }
            }
            
        }
        sideMenuView.setSelectedMenu(type: currentSelectedMenu)
    }
    
    private func setSelectedMenuObject(menuType : Int) -> BaseViewController?{
        
        var controller : BaseViewController?
        
        switch menuType {
        case Menu.home.rawValue:
            
            controller = HomeController()
            
            break
            
        case Menu.profile.rawValue:
            
            controller = ProfileViewController()
            break
            
        case Menu.login.rawValue:
           
            controller = InstagramLoginViewController()
            break
            
        case Menu.feedback.rawValue:
            
            controller = FeedbackViewController()
            break
            
        case Menu.myCollection.rawValue :
            
            controller = MyFavouriteViewController()
            break
            
        case Menu.followers.rawValue:
            
            if AppUtility.isSaveSessionId() == true{
                if AppUtility.getUserDefaultsCustomObjectForKey("userprofilemodel") != nil
                {
                    if let usermodel : UserProfileModel = AppUtility.getUserDefaultsCustomObjectForKey("userprofilemodel") as? UserProfileModel
                    {
                        if followersView == nil
                        {
                            followersView =  MyFollowersViewController.init(followeType: FolloweType.followers,userProfileModel : usermodel)
                        }
                        controller = followersView
                    }
                    else
                    {
                        controller = MyFollowersViewController.init(isFollowers: true)
                    }
                }
                else{
                    controller = MyFollowersViewController.init(isFollowers: true)
                }
            }
            else
            {
                controller = MyFollowersViewController.init(isFollowers: true)
            }
            
            break
       
        case Menu.followings.rawValue:
            if AppUtility.isSaveSessionId() == true{
                if AppUtility.getUserDefaultsCustomObjectForKey("userprofilemodel") != nil
                {
                    if let usermodel : UserProfileModel = AppUtility.getUserDefaultsCustomObjectForKey("userprofilemodel") as? UserProfileModel
                    {
                        if followingsView == nil
                        {
                            followingsView =  MyFollowersViewController.init(followeType: FolloweType.following,userProfileModel : usermodel)
                        }
                        controller = followingsView
                    }
                    else
                    {
                        controller = MyFollowersViewController.init(isFollowers: false)
                    }
                }
                else
                {
                    controller = MyFollowersViewController.init(isFollowers: false)
                }
            }
            else
            {
                controller = MyFollowersViewController.init(isFollowers: false)
            }
            
            break
            
        default:
            break
        }
        
        if menuType == Menu.logout.rawValue{
            AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in
                if self == nil{
                    return
                }
                self?.logoutUser()
            }
            return nil
        }
        else if menuType == Menu.rateUs.rawValue
        {
            let appID = "1241324289"
            if let reviewString = URL(string:"https://itunes.apple.com/us/app/id\(appID)")
            {
                open(url: reviewString)
            }
            else {
                print("invalid url")
            }
        }
        else if menuType == Menu.login.rawValue
        {
            
        }
        else{
            currentSelectedMenu = menuType
        }
        
        defer {
            controller = nil
        }
        
        return controller
    }
    
    func open(url: URL) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                print("Open \(url): \(success)")
            })
        } else {
            if UIApplication.shared.canOpenURL(url as URL)
            {
                UIApplication.shared.openURL(url as URL)
                 print("Open \(url): ")
            }
        }
        
    }
    
    private func updateUIOnLogout(){
        
        self.sideMenuView.loadMenuData()
        self.sideMenuView.showLoginView()
        //AppUtility.getAppDelegate().sideMenuController.hideMenuViewController()
        
        if currentSelectedMenu == Menu.home.rawValue{
            SwiftEventBus.post(LocalNotification.logoutSuccess)
        }
        else
        {
            self.displaySelectedView(type: Menu.home.rawValue)
        }
    }
    
    private func logoutUser() -> Void
    {
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }
            
            let alertView : UIAlertController! = UIAlertController(title: "confirm".localize(), message: "logoutConfirm".localize(), preferredStyle: UIAlertControllerStyle.alert)
            
            alertView.addAction(UIAlertAction(title: "no".localize(), style: .destructive, handler: nil))
            alertView.addAction(UIAlertAction(title: "yes".localize(), style: .default, handler: { [weak self] (action) in
                if self == nil{
                    return
                }
                self?.userProfileLogoutRequest()
            }))
            
            self?.present(alertView, animated: true, completion: nil)
        }
    }
   
    
    // TODO: - IN APP PURCHASE -
    
    // MARK:- Purchase
    /**
     This Method Is used for purchase product
     */
   
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
    public func userProfileLogoutRequest()
    {
        sideMenuView.operationQueue.addOperation { [weak self] in
            if self == nil{
                return
            }
            let dicParameter : NSMutableDictionary = NSMutableDictionary()
            
            var headers : HTTPHeaders = HTTPHeaders.init()
            let csrftoken = AppUtility.getCsrftokenFromUserDefaults()
            let mid = AppUtility.getMidFromUserDefaults()
            let sessionid = AppUtility.getSessionidFromUserDefaults()
            let ds_user_id = AppUtility.getDs_user_idFromUserDefaults()
            
            headers[APIConstant.referer] = APIConstant.baseURL
            headers[APIConstant.xcsrftoken] = csrftoken
            headers[APIConstant.rur] = "ATN"
            
            headers[APIConstant.cookie] = "\(APIConstant.csrftoken)=\(csrftoken);                                              \(APIConstant.mid)=\(mid);                                                          \(APIConstant.ig_vw)=1535;                                                          \(APIConstant.ig_pr)=\(APIConstant.ig_prValue);                                         \(APIConstant.ds_user_id)=\(ds_user_id);                                            \(APIConstant.sessionid)=\(sessionid);                                              \(APIConstant.s_network)="
            headers[APIConstant.ig_pr] = APIConstant.ig_prValue
            headers[APIConstant.ig_vw] = APIConstant.ig_vwValue
            headers[APIConstant.s_network] = ""
            headers[APIConstant.accept] = APIConstant.accepthtml
            headers["upgrade-insecure-requests"] = "1"
            
            let userprofileApi = "\(APIConstant.logout)"
            dicParameter .setValue(csrftoken, forKey: "csrfmiddlewaretoken")
            
            BaseAPICall.shared.postReques(URL: userprofileApi, Parameter: dicParameter, Type: APITask.Logout, Headers: headers, completionHandler: {  [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(_, _):
                    AppUtility.deleteAllCookies()
                    AppUtility.clearUserDefaultsForKey(UserDefaultKey.userprofilemodel)
                    AppUtility.clearUserDefaultsForKey(UserDefaultKey.LoginUserName)
                    AppUtility.clearUserDefaultsForKey(UserDefaultKey.loginUserData)
                    AppUtility.clearUserDefaultsForKey(APIConstant.sessionid)
                    AppUtility.clearUserDefaultsForKey(APIConstant.rur)
                    AppUtility.clearUserDefaultsForKey(APIConstant.csrftoken)
                    AppUtility.clearUserDefaultsForKey(APIConstant.mid)
                    self?.sideMenuView.hideProgressHUD()
                    self?.updateUIOnLogout()
                    
                    break
                case .Error( _):
                    
                    self?.sideMenuView.hideProgressHUD()
                    AppUtility.deleteAllCookies()
                    AppUtility.clearUserDefaultsForKey(UserDefaultKey.userprofilemodel)
                    AppUtility.clearUserDefaultsForKey(UserDefaultKey.LoginUserName)
                    AppUtility.clearUserDefaultsForKey(UserDefaultKey.loginUserData)
                    AppUtility.clearUserDefaultsForKey(APIConstant.sessionid)
                    AppUtility.clearUserDefaultsForKey(APIConstant.rur)
                    AppUtility.clearUserDefaultsForKey(APIConstant.csrftoken)
                    AppUtility.clearUserDefaultsForKey(APIConstant.mid)
                    
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil {
                            return
                        }
                    }
                    self?.updateUIOnLogout()
                    break
                case .Internet(let isOn):
                    self?.sideMenuView.handleNetworkCheck(isAvailable: isOn, viewController: self!.sideMenuView, showLoaddingView: true)
                    break
                }
            })
        }
    }
}
