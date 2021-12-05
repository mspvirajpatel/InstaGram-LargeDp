//
//  LoginView.swift
//  InstaLargerDp
//
//  Created by Viraj Patel on 09/12/16.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import Alamofire

enum FolloweType : Int{
    case following = 1
    case followers = 0
}

enum Menu : Int{
    case home = 0
    case profile = 1
    case login = 2
    case logout = 3
    case rateUs = 4
    case feedback = 5
    case myCollection = 6
    case followers = 7
    case followings = 8
}

enum SearchType : Int{
    case people = 1
}

enum ImageEditorViewType : Int {
    case unknown = -1
    case timeLine = 4
    case profile = 5
    case follow = 7
    case searchUser = 8
    case anyobject = 9
}

class InstagramLoginView: BaseView,UIWebViewDelegate {
    
    // MARK: - Attributes -
    
    var webView : UIWebView!
    var authURL: String? = nil
    fileprivate var loginSuccessEvent : TaskFinishedEvent!
    var timeline : TimeLine!
    var isLoad : Bool!
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func releaseObject() {
        super.releaseObject()
        
        if webView != nil && webView.superview != nil {
            webView.removeFromSuperview()
            webView = nil
        }
        loginSuccessEvent = nil
        timeline = nil
        
    }
    
    deinit {
        print("LoginView Deinit called")
        self.releaseObject()
    }
    
    
    // MARK: - Layout -
    
    override func loadViewControls() {
        super.loadViewControls()
        
        let storage : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        isLoad = false
        
        AppUtility.deleteAllCookies()
        AppUtility.clearUserDefaultsForKey(UserDefaultKey.userprofilemodel)
        AppUtility.clearUserDefaultsForKey(UserDefaultKey.LoginUserName)
        AppUtility.clearUserDefaultsForKey(UserDefaultKey.loginUserData)
        AppUtility.clearUserDefaultsForKey(APIConstant.sessionid)
        AppUtility.clearUserDefaultsForKey(APIConstant.rur)
        AppUtility.clearUserDefaultsForKey(APIConstant.csrftoken)
        AppUtility.clearUserDefaultsForKey(APIConstant.mid)
        
        webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = UIColor.clear
        
        authURL = "\(Instagram_data.KInstagramLogin)"
        
        self.addSubview(webView)
        AppUtility.isNetworkAvailableWithBlock { [weak self] (isAvailable) in
            if self == nil{
                return
            }
            if isAvailable == true{
                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                    if self == nil
                    {
                        return
                    }
                    self!.showProgressHUD(viewController: self!, title:NSLocalizedString("loading", comment: ""), subtitle: nil)
                    self!.webView.loadRequest(URLRequest(url: URL(string: self!.authURL!)!))
                }
            }
            else{
                self?.displayBottomToast(message: ErrorMessage.noInternet)
            }
        }
        webView.delegate = self
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        webView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.layoutIfNeeded()
        
    }
    
    // MARK: - UIWebView Delegate -
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        let storage : HTTPCookieStorage = HTTPCookieStorage.shared
        
        if storage.cookies != nil
        {
            for cookie in storage.cookies!
            {
                var cookieProperties = [HTTPCookiePropertyKey : Any]()
                cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
                cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
                cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain
                cookieProperties[HTTPCookiePropertyKey.path] = cookie.path
                cookieProperties[HTTPCookiePropertyKey.version] = NSNumber(value: cookie.version)
                cookieProperties[HTTPCookiePropertyKey.expires] = NSDate().addingTimeInterval(31536000)
                
                let newCookie = HTTPCookie(properties: cookieProperties )
                HTTPCookieStorage.shared.setCookie(newCookie!)
                
                if  cookie.name == APIConstant.sessionid
                {
                    let strsession : String? = AppUtility.getUserDefaultsObjectForKey(cookie.name) as? String
                    if strsession == nil || strsession == ""
                    {
                        if cookie.value != ""
                        {
                            AppUtility.setUserDefaultsObject(cookie.value as AnyObject, forKey: cookie.name)
                        }
                    }
                }
                else{
                    AppUtility.setUserDefaultsObject(cookie.value as AnyObject, forKey: cookie.name)
                }
                print("name: \(cookie.name) value: \(cookie.value)")
            }
        }
        
        if AppUtility.getSessionidFromUserDefaults() != ""
        {
            self.webViewDidFinishLoad(webView)
            if !isLoad
            {
                isLoad = true
                let sessionid: String = AppUtility.getSessionidFromUserDefaults()
                var pos = 0
                var end = 0
                let string = sessionid.removingPercentEncoding!
                let needle: Character = "{"
                if let idx = string.index(of: needle)
                {
                    pos =  string.distance(from: string.startIndex, to: idx)
                }
                else
                {
                    print("Not found")
                }
                
                let needle1: Character = "}"
                if let idx = string.index(of: needle1)
                {
                    end =  string.distance(from: string.startIndex, to: idx)
                    print("Found \(needle1) at position \(end)")
                }
                else
                {
                    print("Not found")
                }
                
                let new: String = string.substring(pos, length: string.count-pos)
                
                UserDefaults.standard.synchronize()
                
                let isSaveLogin : Bool = AppUtility.saveLoginUserModel(modelDictString: new)
                if isSaveLogin == true{
                
                    self.instagramTimeLineRequest(isShowLoadding: true)
                    
                }
            }
        }
        else{
            if request.url != nil
            {
                print("request: \(request)")
                let urlString: String = request.url!.absoluteString as String
                
                var pos = 0
                
                let string = urlString.removingPercentEncoding!
                let needle: Character = "?"
                if let idx = string.index(of: needle)
                {
                    pos =  string.distance(from: string.startIndex, to: idx)
                }
                else
                {
                    print("Not found")
                }
                
                let new: String = string.substring(0, length: pos)
                
                let datais : String = "https://www.instagram.com/accounts/password/reset/done/"
                
                if new == datais
                {
                    self.webView.loadRequest(URLRequest(url: URL(string: self.authURL!)!))
                }
            }
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        webView.layer.removeAllAnimations()
        webView.isUserInteractionEnabled = false
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideProgressHUD()
        webView.layer.removeAllAnimations()
        webView.isUserInteractionEnabled = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.webViewDidFinishLoad(webView)
    }
    
    // MARK: - Public Method
    open func loginEvent(event : @escaping TaskFinishedEvent) -> Void{
        loginSuccessEvent = event
    }
    
    // MARK: - Server Request -
    open func instagramTimeLineRequest(isShowLoadding: Bool)
    {
        if operationQueue == nil{
            return
        }
        
        operationQueue.addOperation { [weak self] in
            if self == nil{
                return
            }
            
            var headers : HTTPHeaders = HTTPHeaders.init()
            let rur = AppUtility.getRurFromUserDefaults()
            let csrftoken = AppUtility.getCsrftokenFromUserDefaults()
            let mid = AppUtility.getMidFromUserDefaults()
            let sessionid = AppUtility.getSessionidFromUserDefaults()
            let ds_user_id = AppUtility.getDs_user_idFromUserDefaults()
            
            headers[APIConstant.referer] = APIConstant.baseURL
            headers[APIConstant.xcsrftoken] = csrftoken
            headers[APIConstant.cookie] = "\(APIConstant.rur)=\(rur);                                       \(APIConstant.csrftoken)=\(csrftoken);                                              \(APIConstant.mid)=\(mid);                                                          \(APIConstant.ig_vw)=1535;                                                          \(APIConstant.ig_pr)=\(APIConstant.ig_prValue);                                         \(APIConstant.ds_user_id)=\(ds_user_id);                                            \(APIConstant.sessionid)=\(sessionid);                                              \(APIConstant.s_network)="
            headers[APIConstant.ig_pr] = APIConstant.ig_prValue
            headers[APIConstant.ig_vw] = APIConstant.ig_vwValue
            headers[APIConstant.s_network] = ""
            headers[APIConstant.accept] = APIConstant.acceptjson
            
            let instagramTimeLineApi = APIConstant.timeline
            
            BaseAPICall.shared.getInstgramRequest(URL: instagramTimeLineApi, Parameter: NSDictionary(), Task: APITask.TimeLine,Headers: headers, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(let object, _):
                    
                    if object is TimeLine
                    {
                        self?.timeline = object as! TimeLine
                       
                        if self?.timeline != nil && self?.timeline.graphql != nil && self?.timeline.graphql.user != nil && self?.timeline.graphql.user.username != ""
                        {
                            AppUtility.setUserDefaultsObject(self?.timeline.graphql.user.username as AnyObject, forKey: UserDefaultKey.LoginUserName)
                            
                            if self?.loginSuccessEvent != nil{
                                self?.loginSuccessEvent(true,nil)
                            }
                        }
                        
                    }
                    break
                case .Error(let error):
                    self!.hideProgressHUD()
                    
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil {
                            return
                        }
                        self?.displayBottomToast(message: error!.serverMessage)
                      
                    }
                    break
                case .Internet(let isOn):
                    
                    self!.handleNetworkCheck(isAvailable: isOn, viewController: AppUtility.getAppDelegate().window!, showLoaddingView: isShowLoadding)
                    break
                }
            })
        }
        
        
    }
    
    
}
