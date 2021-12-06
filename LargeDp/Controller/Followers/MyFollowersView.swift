//
//  MyFollowersView.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 13/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftEventBus
//import GoogleMobileAds
import GRDB

class MyFollowersView: BaseView {
    
    // Mark: - Attributes -
    var tableView : UITableView!
    var refreshControlSent : UIRefreshControl!
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    private var searchText : String = ""
    
//    var loadStateForAds : [GADNativeExpressAdView: Bool]! = [:]
//    var adsToLoad : [GADNativeExpressAdView]! = []
    var adViewHeight : CGFloat = SystemConstants.IS_IPAD ? 110 : 90
//    var adView = GADNativeExpressAdView()
    var adInterval = UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4
    
    var typeofFollowers : FolloweType! = FolloweType.followers
    var isLoading : Bool = false
    var myFollowersModel : MyFollowers!
    var anyobject : NSMutableArray! = NSMutableArray.init()
    var adBigViewHeight : CGFloat = SystemConstants.IS_IPAD ? 280 : 280
    var userprofile : UserProfileModel!
    
    var viewContant : UIView!
    var addContant : UIView!
    var loginButtonContant : UIView!
    var lblMessage : BaseLabel!
    var btnLogin : BaseButton!
    var isFollower : Bool!
    var isSmall : Bool!
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    init(isFollowers: Bool) {
        
        super.init(frame: .zero)
        isFollower = isFollowers
        isSmall = false
        
        self.loadAddViewControls()
        self.setAddViewlayout()
    }
    
    init(followeType : FolloweType, userProfileModel : UserProfileModel)
    {
        super.init(frame: .zero)
        
        userprofile = userProfileModel
        isSmall = true
        typeofFollowers = followeType
        self.loadViewControls()
        self.setViewlayout()
        
        switch typeofFollowers.rawValue
        {
        case 0:
            self.myFollowers()
            break
        case 1:
            
            self.myFollowings()
            break
        default:
            break
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("PeopleListView deinit called")
        self.releaseObject()
    }
    
    override func releaseObject()
    {
        super.releaseObject()
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if refreshControlSent != nil && refreshControlSent.superview != nil {
            refreshControlSent.removeFromSuperview()
            refreshControlSent = nil
        }
        
        if tableView != nil && tableView.superview != nil {
            tableView.removeFromSuperview()
            tableView = nil
        }
        
        if viewContant != nil && viewContant.superview != nil {
            viewContant.removeFromSuperview()
            viewContant = nil
        }
        
        if lblMessage != nil && lblMessage.superview != nil {
            lblMessage.removeFromSuperview()
            lblMessage = nil
        }
        
        if btnLogin != nil && btnLogin.superview != nil {
            btnLogin.removeFromSuperview()
            btnLogin = nil
        }
        
        if refreshControlSent != nil && refreshControlSent.superview != nil {
            refreshControlSent.removeFromSuperview()
            refreshControlSent = nil
        }
        
        typeofFollowers = nil
        myFollowersModel = nil
        userprofile = nil
        btnTouchUpInside = nil
//        adsToLoad = nil
//        loadStateForAds = nil
    }
    
    func loadAddViewControls() {
        super.loadViewControls()
        
        viewContant = UIView(frame: .zero)
        viewContant.translatesAutoresizingMaskIntoConstraints = false
        viewContant.backgroundColor = Color.appSecondaryBG.value
        self.addSubview(viewContant)

        addContant = UIView(frame: .zero)
        addContant.translatesAutoresizingMaskIntoConstraints = false
        addContant.backgroundColor = Color.appSecondaryBG.value
        self.addSubview(addContant)
       
        loginButtonContant = UIView(frame: .zero)
        loginButtonContant.translatesAutoresizingMaskIntoConstraints = false
        loginButtonContant.backgroundColor = Color.appSecondaryBG.value
        self.addSubview(loginButtonContant)
        
        
        refreshControlSent = UIRefreshControl()
        refreshControlSent.attributedTitle = NSAttributedString(string: "pullToRefresh".localize())
        refreshControlSent.addTarget(self, action: #selector(refreshPlaceList), for: UIControl.Event.valueChanged)

        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        addContant.addSubview(tableView)
        tableView.bounces = false
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = .zero
        
        tableView.separatorStyle = .none
        tableView.register(NativeAddCell.self, forCellReuseIdentifier: CellIdentifire.nativeCell)
        tableView.addSubview(refreshControlSent)
        
        btnLogin = BaseButton(ibuttonType: .primary, iSuperView: loginButtonContant)
    
        btnLogin.setTitle("Login", for: .normal)
        
        btnLogin.setButtonTouchUpInsideEvent { [weak self] (object, sender) in
            if self == nil {
                return
            }
            
            let navController : BaseNavigationController! = BaseNavigationController(rootViewController: InstagramLoginViewController())
            AppUtility.getAppDelegate().navigationController.present(navController, animated:true, completion: nil)
            
        }
        
        lblMessage = BaseLabel(labelType: BaseLabelType.small, superView: viewContant)
        lblMessage.numberOfLines = 0
        if isFollower == true
        {
             lblMessage.text = "Please login to view the large profile picture of your Followers.".localize()
        }
       else
        {
             lblMessage.text = "Please login to view the large profile picture of your Followings.".localize()
        }
        
        
        lblMessage.textAlignment = .center

    }
    
    func setAddViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = ["viewContant" :viewContant,
                                     "addContant" :addContant,
                                     "loginButtonContant" :loginButtonContant,
                                     "btnLogin" :btnLogin,
                                     "lblMessage" :lblMessage,
                                     "tableView" : tableView ]
        
        
        let horizontalPadding : CGFloat = ControlLayout.horizontalPadding
        let verticalPadding : CGFloat = ControlLayout.verticalPadding
        let secondaryHorizontalPadding : CGFloat = ControlLayout.secondaryHorizontalPadding
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        
        self.baseLayout.metrics = ["horizontalPadding" : horizontalPadding,
                                   "verticalPadding" : verticalPadding,
                                   "secondaryHorizontalPadding" : secondaryHorizontalPadding,
                                   "secondaryVerticalPadding" : secondaryVerticalPadding]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContant]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
//        baseLayout.position_CenterX = NSLayoutConstraint(item: addContant, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
//        self.addConstraint(baseLayout.position_CenterX)
//        
        baseLayout.position_CenterY = NSLayoutConstraint(item: addContant, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.addConstraint(baseLayout.position_CenterY)
      
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[viewContant]-20-[addContant(280)]-[loginButtonContant]", options: [.alignAllLeading, .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: btnLogin, attribute: .centerX, relatedBy: .equal, toItem: loginButtonContant, attribute: .centerX, multiplier: 1.0, constant: 0)
        loginButtonContant.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.size_Width = NSLayoutConstraint(item: btnLogin, attribute: .width, relatedBy: .equal, toItem: loginButtonContant, attribute: .width, multiplier: 0.87, constant: 0)
        loginButtonContant.addConstraint(baseLayout.size_Width)
        
//        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnLogin]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
//        loginButtonContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnLogin]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        loginButtonContant.addConstraints(baseLayout.control_V)
       
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblMessage]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblMessage]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_V)
        
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: addContant, attribute: .centerX, multiplier: 1.0, constant: 0)
        addContant.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.size_Width = NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: addContant, attribute: .width, multiplier: 0.9, constant: 0)
        addContant.addConstraint(baseLayout.size_Width)
        
//        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15@751-[tableView]-15@751-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
//        addContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        addContant.addConstraints(baseLayout.control_V)
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        do {
            baseLayout.releaseObject()
        }
        
    }
    
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
        refreshControlSent = UIRefreshControl()
        refreshControlSent.attributedTitle = NSAttributedString(string: "pullToRefresh".localize())
        refreshControlSent.addTarget(self, action: #selector(refreshPlaceList), for: UIControl.Event.valueChanged)
        
        
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = .zero
        tableView.addSubview(refreshControlSent)
        tableView.separatorStyle = .none
        tableView.register(NativeAddCell.self, forCellReuseIdentifier: CellIdentifire.nativeCell)
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: CellIdentifire.people)
        tableView.addInfiniteScroll { [weak self] (tableViews) -> Void in
            
            if self == nil{
                return
            }
            
            if self?.myFollowersModel != nil
            {
                switch self?.typeofFollowers.rawValue
                {
                case 0?:
                    if self?.myFollowersModel != nil && self?.myFollowersModel.data != nil && self?.myFollowersModel.data.user != nil && self?.myFollowersModel.data.user.edgeFollowedBy != nil && self?.myFollowersModel.data.user.edgeFollowedBy.pageInfo != nil
                    {
                        self!.paginationFollowersRequest()
                        return
                    }
                    break
                case 1?:
                    
                    if self?.myFollowersModel.data != nil && self?.myFollowersModel.data.user != nil && self?.myFollowersModel.data.user.edgeFollow != nil && self?.myFollowersModel.data.user.edgeFollow.pageInfo != nil
                    {
                        self?.paginationFollowingsRequest()
                        return
                    }
                    break
                default:
                    break
                }
            }
            self?.tableView.finishInfiniteScroll()
            
        }
    }
    
    
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = ["tableView" : tableView]
        
        let horizontalPadding : CGFloat = ControlLayout.horizontalPadding
        let verticalPadding : CGFloat = ControlLayout.verticalPadding
        let secondaryHorizontalPadding : CGFloat = ControlLayout.secondaryHorizontalPadding
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        
        self.baseLayout.metrics = ["horizontalPadding" : horizontalPadding,
                                   "verticalPadding" : verticalPadding,
                                   "secondaryHorizontalPadding" : secondaryHorizontalPadding,
                                   "secondaryVerticalPadding" : secondaryVerticalPadding]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        do {
            baseLayout.releaseObject()
        }
        
    }
    
    // MARK: - Public Interface -
    @objc func refreshPlaceList()
    {
        switch typeofFollowers.rawValue
        {
        case 0:
            self.refreshControlSent.endRefreshing()
            self.myFollowers()
            break
        case 1:
            self.refreshControlSent.endRefreshing()
            self.myFollowings()
            break
        default:
            break
        }
        
    }
    
    func addBigNativeExpressAds() {
        
//        let adSize = GADAdSizeFromCGSize(
//            CGSize(width: tableView.contentSize.width, height: adBigViewHeight))
//        self.adView = GADNativeExpressAdView(adSize: adSize)!
//        
//        adView.adUnitID = InAddvertise.kBigNativeadd
//        if let controller : UIViewController = self.getViewControllerFromSubView(){
//            adView.rootViewController = controller
//            adView.load(GADRequest())
//        }
//
//        anyobject.insert(adView, at: 0)
//        
//        adsToLoad.append(adView)
//        
//        self.loadStateForAds[adView] = true
//      
//        self.tableView.reloadData()
        
        
//        let adSize = GADAdSizeFromCGSize(
//            CGSize(width:  self.frame.width*0.9 , height: 250))
//        adView = GADNativeExpressAdView(adSize: adSize)!
//        
//        adView.adUnitID = InAddvertise.kBigNativeadd
//        self.adView.load(GADRequest())
//        adView.rootViewController = self
//        
//        
//        anyobject.insert(adView, at: 0)
//        
//        adsToLoad.append(adView)
//        
//        loadStateForAds[adView] = true
//        
//        self.tableView.reloadData()
        
    
        
    }
    
    func addNativeExpressAds() {
      
//        var index = adInterval
//
//        while index < anyobject.count {
//            let adSize = GADAdSizeFromCGSize(
//                CGSize(width: tableView.contentSize.width - 10, height: adViewHeight))
//            self.adView = GADNativeExpressAdView(adSize: adSize)!
//
//            adView.adUnitID = InAddvertise.kNativeadd
//            if let controller : UIViewController = self.getViewControllerFromSubView(){
//                adView.rootViewController = controller
//                adView.load(GADRequest())
//            }
//
//            anyobject.insert(adView, at: index)
//
//            switch typeofFollowers.rawValue
//            {
//            case 0:
//                myFollowersModel.data.user.edgeFollowedBy.edges.insert(FollowersEdge.init(fromDictionary: [:]), at: index)
//                break
//            case 1:
//                myFollowersModel.data.user.edgeFollow.edges.insert(FollowersEdge.init(fromDictionary: [:]), at: index)
//                break
//            default:
//                break
//            }
//
//
//            index += adInterval
//            adsToLoad.append(adView)
//
//            self.loadStateForAds[adView] = true
//        }
     
    }
    
    func addNativeExpressAds(temparray : [FollowersEdge]) {

        var temparrays :  [AnyObject] = temparray
        var index = adInterval

//        while index < temparrays.count {
//            let adSize = GADAdSizeFromCGSize(
//                CGSize(width: tableView.contentSize.width, height: adViewHeight))
//            self.adView = GADNativeExpressAdView(adSize: adSize)!
//
//            adView.adUnitID = InAddvertise.kNativeadd
//
//            temparrays.insert(adView, at: index)
//
//            switch typeofFollowers.rawValue
//            {
//            case 0:
//                myFollowersModel.data.user.edgeFollowedBy.edges.insert(FollowersEdge.init(fromDictionary: [:]), at: index)
//                break
//            case 1:
//                myFollowersModel.data.user.edgeFollow.edges.insert(FollowersEdge.init(fromDictionary: [:]), at: index)
//                break
//            default:
//                break
//            }
//
//            adsToLoad.append(adView)
//
//            if let controller : UIViewController = self.getViewControllerFromSubView(){
//                adView.rootViewController = controller
//                adView.load(GADRequest())
//            }
//            index += adInterval
//
//            self.loadStateForAds[adView] = true
//        }
//
//        self.anyobject.addObjects(from: temparrays)
        
    }
    
    
    func myFollowers(){
        if isLoadedRequest == false{
            isLoadedRequest = true
            self.myFollowersRequest()
        }
    }
    
    func myFollowings(){
        if isLoadedRequest == false{
            isLoadedRequest = true
            self.myFollowingsRequest()
        }
    }
    
    
    // MARK: - User Interaction -
    
    func refresh()
    {
        switch typeofFollowers.rawValue
        {
        case 0:
            self.myFollowers()
            break
        case 1:
            
            self.myFollowings()
            break
        default:
            break
        }
    }
    
    
    // MARK: - Internal Helpers -
    func btnTapped(event: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = event
    }
    
    
    // MARK: - Server Request -
    public func myFollowersRequest()
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
            
            
            var followingsApi = ""
            
            if self?.userprofile != nil && self?.userprofile.user != nil{
                followingsApi = "graphql/query/?query_id=17851374694183129&id=\(self!.userprofile.user.id!)&first=100"
            }
            else{
                followingsApi = "graphql/query/?query_id=17851374694183129&id=\(ds_user_id)&first=100"
            }
            
            BaseAPICall.shared.getInstgramRequest(URL: followingsApi, Parameter: NSDictionary(), Task: APITask.MyFollowers,Headers: headers, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result
                {
                case .Success(let object, _):
                    self!.hideProgressHUD()
                    self?.isLoading = false
                    self?.isLoadedRequest = false
                    
                    if object is MyFollowers
                    {
                        self?.myFollowersModel = object as! MyFollowers
                        self?.anyobject.removeAllObjects()

                        if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool
                        {
                            if !isPremium
                            {
                                 self?.addNativeExpressAds(temparray: (self?.myFollowersModel.data.user.edgeFollowedBy.edges)!)
                            }
                            else
                            {
                                self?.anyobject.addObjects(from: (self?.myFollowersModel.data.user.edgeFollowedBy.edges)!)
                            }
                        }
                        else
                        {
                            self?.anyobject.addObjects(from: (self?.myFollowersModel.data.user.edgeFollowedBy.edges)!)
                        }
                       
                        
                        self?.tableView.reloadData()
                        
                        InterfaceUtility.animateCellTableView(tableview: (self?.tableView)!)
                    }
                    break
                case .Error(let error):
                    self?.isLoading = false
                    self?.isLoadedRequest = false
                    self!.hideProgressHUD()
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil {
                            return
                        }
                        self?.tableView.reloadData()
                        self?.displayBottomToast(message: error!.serverMessage)
                     
                    }
                    break
                case .Internet(let isOn):
                    self!.handleNetworkCheck(isAvailable: isOn, viewController: self!, showLoaddingView: true)
                    
                    break
                }
            })
        }
        
    }
    
    public func myFollowingsRequest()
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
            
            
            var followingsApi = ""
            
            if self?.userprofile != nil && self?.userprofile.user != nil
            {
                followingsApi = "graphql/query/?query_id=17874545323001329&id=\(self!.userprofile.user.id!)&first=100"
            }
            else
            {
                followingsApi = "graphql/query/?query_id=17874545323001329&id=\(ds_user_id)&first=100"
            }
            
            BaseAPICall.shared.getInstgramRequest(URL: followingsApi, Parameter: NSDictionary(), Task: APITask.MyFollowers,Headers: headers, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(let object, _):
                    self!.hideProgressHUD()
                    self?.isLoading = false
                    self?.isLoadedRequest = false
                    
                    if object is MyFollowers
                    {
                        self?.myFollowersModel = object as! MyFollowers
                        self?.anyobject.removeAllObjects()
                        if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool
                        {
                            if !isPremium
                            {
                                self?.addNativeExpressAds(temparray: (self?.myFollowersModel.data.user.edgeFollow.edges)!)
                            }
                            else
                            {
                               self?.anyobject.addObjects(from: (self?.myFollowersModel.data.user.edgeFollow.edges)!)
                            }
                        }
                        else
                        {
                            self?.anyobject.addObjects(from: (self?.myFollowersModel.data.user.edgeFollow.edges)!)
                        }

                        
                        
                        //self?.addNativeExpressAds()
                        self?.tableView.reloadData()
                        InterfaceUtility.animateCellTableView(tableview: (self?.tableView)!)
                    }
                    
                    break
                case .Error(let error):
                    self?.isLoading = false
                    self?.isLoadedRequest = false
                    self!.hideProgressHUD()
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil {
                            return
                        }
                         self?.tableView.reloadData()
                       self?.displayBottomToast(message: error!.serverMessage)
                    }
                    break
                case .Internet(let isOn):
                    self!.handleNetworkCheck(isAvailable: isOn, viewController: self!, showLoaddingView: true)
                    
                    break
                }
            })
        }
    }
    
    
    public func paginationFollowersRequest()
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
            
            
            var followingsApi = ""
            
            if self?.userprofile.user != nil && self!.myFollowersModel != nil && self!.myFollowersModel.data != nil && self!.myFollowersModel.data.user != nil && self!.myFollowersModel.data.user.edgeFollowedBy != nil && self!.myFollowersModel.data.user.edgeFollowedBy.pageInfo != nil && self!.myFollowersModel.data.user.edgeFollowedBy.pageInfo.endCursor != nil
            {
                followingsApi = "graphql/query/?query_id=17851374694183129&id=\(self!.userprofile.user.id!)&first=100&after=\(self!.myFollowersModel.data.user.edgeFollowedBy.pageInfo.endCursor!)"
            }
            
            if followingsApi == ""
            {
                self?.tableView.finishInfiniteScroll()
                self?.tableView.removeInfiniteScroll()
                return
            }
            
            BaseAPICall.shared.getInstgramRequest(URL: followingsApi, Parameter: NSDictionary(), Task: APITask.MyFollowers,Headers: headers, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result
                {
                case .Success(let object, _):
                    self!.hideProgressHUD()
                    
                    if object is MyFollowers
                    {
                        let myFolllowes: MyFollowers = object as! MyFollowers
                        
                        if self?.myFollowersModel.data != nil && self?.myFollowersModel.data.user != nil && self?.myFollowersModel.data.user.edgeFollowedBy != nil
                        {
                            if myFolllowes.data != nil && myFolllowes.data.user != nil && myFolllowes.data.user.edgeFollowedBy != nil
                            {
                                self?.myFollowersModel.data.user.edgeFollowedBy.edges.append(contentsOf: myFolllowes.data.user.edgeFollowedBy.edges)
                                self?.myFollowersModel.data.user.edgeFollowedBy.count = myFolllowes.data.user.edgeFollowedBy.count
//                                self?.anyobject.addObjects(from: (myFolllowes.data.user.edgeFollowedBy.edges)!)
//                                self?.addNativeExpressAds()
                                
                                if myFolllowes.data.user.edgeFollowedBy.pageInfo != nil
                                {
                                    self?.myFollowersModel.data.user.edgeFollowedBy.pageInfo = myFolllowes.data.user.edgeFollowedBy.pageInfo
                                }
                                
                                if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool
                                {
                                    if !isPremium
                                    {
                                         self?.addNativeExpressAds(temparray: (myFolllowes.data.user.edgeFollowedBy.edges)!)
                                    }
                                    else
                                    {
                                       self?.anyobject.addObjects(from: (myFolllowes.data.user.edgeFollowedBy.edges)!)
                                    }
                                }
                                else
                                {
                                    self?.anyobject.addObjects(from: (myFolllowes.data.user.edgeFollowedBy.edges)!)
                                }
                                
                                self?.tableView.reloadData()
                            }
                            else{
                                self?.tableView.removeInfiniteScroll()
                            }
                        }
                    }
                    
                    self?.tableView.finishInfiniteScroll()
                    self?.tableView.reloadData()
                    // InterfaceUtility.animateCellTableView(tableview: (self?.tableView)!)
                    break
                case .Error(let error):
                    self!.hideProgressHUD()
                    self?.tableView.finishInfiniteScroll()
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil {
                            return
                        }
                        self?.displayBottomToast(message: error!.serverMessage)
                    }
                    break
                case .Internet(let isOn):
                    self!.handleNetworkCheck(isAvailable: isOn, viewController: self!, showLoaddingView: false)
                    
                    break
                }
            })
        }
    }
    
    public func paginationFollowingsRequest()
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
            
            
            var followingsApi = ""
            
            
            if self?.userprofile.user != nil && self!.myFollowersModel != nil && self!.myFollowersModel.data != nil && self!.myFollowersModel.data.user != nil && self!.myFollowersModel.data.user.edgeFollow != nil && self!.myFollowersModel.data.user.edgeFollow.pageInfo != nil && self!.myFollowersModel.data.user.edgeFollow.pageInfo.endCursor != nil
            {
                followingsApi = "graphql/query/?query_id=17874545323001329&id=\(self!.userprofile.user.id!)&first=100&after=\(self!.myFollowersModel.data.user.edgeFollow.pageInfo.endCursor!)"
            }
            
            if followingsApi == ""
            {
                self?.tableView.finishInfiniteScroll()
                self?.tableView.removeInfiniteScroll()
                return
            }
            
            BaseAPICall.shared.getInstgramRequest(URL: followingsApi, Parameter: NSDictionary(), Task: APITask.MyFollowers,Headers: headers, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(let object, _):
                    self!.hideProgressHUD()
                    
                    if object is MyFollowers
                    {
                        if self?.myFollowersModel.data != nil && self?.myFollowersModel.data.user != nil && self?.myFollowersModel.data.user.edgeFollow != nil
                        {
                            let myFolllowes: MyFollowers = object as! MyFollowers
                            
                            if myFolllowes.data != nil && myFolllowes.data.user != nil && myFolllowes.data.user.edgeFollow != nil
                            {
                                self?.myFollowersModel.data.user.edgeFollow.edges.append(contentsOf: myFolllowes.data.user.edgeFollow.edges)
                                
                                self?.myFollowersModel.data.user.edgeFollow.count = myFolllowes.data.user.edgeFollow.count
                                
                                if myFolllowes.data.user.edgeFollow.pageInfo != nil
                                {
                                    self?.myFollowersModel.data.user.edgeFollow.pageInfo = myFolllowes.data.user.edgeFollow.pageInfo
                                }
                                
                                if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool
                                {
                                    if !isPremium
                                    {
                                       self?.addNativeExpressAds(temparray: (myFolllowes.data.user.edgeFollow.edges)!)
                                    }
                                    else
                                    {
                                        self?.anyobject.addObjects(from: (myFolllowes.data.user.edgeFollow.edges)!)
                                    }
                                }
                                else
                                {
                                    self?.anyobject.addObjects(from: (myFolllowes.data.user.edgeFollow.edges)!)
                                }
                                
//                                self?.anyobject.addObjects(from: (myFolllowes.data.user.edgeFollow.edges)!)
//                                
//                                self?.addNativeExpressAds()
                                
                                
                                self?.tableView.reloadData()
                            }
                            else{
                                self?.tableView.removeInfiniteScroll()
                            }
                        }
                    }
                    self?.tableView.finishInfiniteScroll()
                    
                    //  InterfaceUtility.animateCellTableView(tableview: (self?.tableView)!)
                    break
                case .Error(let error):
                    self!.hideProgressHUD()
                    self?.tableView.finishInfiniteScroll()
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil {
                            return
                        }
                        self?.displayBottomToast(message: error!.serverMessage)
                    }
                    break
                case .Internet(let isOn):
                    self!.handleNetworkCheck(isAvailable: isOn, viewController: self!, showLoaddingView: false)
                    
                    break
                }
            })
        }
    }
    
    
}

extension MyFollowersView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if anyobject != nil && anyobject.count > 0{
            self.displayErrorMessageLabel("")
            self.errorMessageLabel.isHidden = true
            return anyobject.count
        }
        else
        {
            self.errorMessageLabel.textColor = Color.activityText.value
            self.displayErrorMessageLabel("noFound".localize())
            self.bringSubviewToFront(self.errorMessageLabel)
            self.errorMessageLabel.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if myFollowersModel != nil {
            
            switch typeofFollowers.rawValue
            {
            case 0:
                
//                if let nativeExpressAdView = anyobject[indexPath.row] as? GADNativeExpressAdView
//                {
//                    let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.nativeCell,for: indexPath)
//                    for subview in reusableAdCell.contentView.subviews {
//                        subview.removeFromSuperview()
//                    }
//                    reusableAdCell.contentView.addSubview(nativeExpressAdView)
//                    nativeExpressAdView.center = reusableAdCell.contentView.center
//
//                    reusableAdCell.selectionStyle = .none
//                    reusableAdCell.backgroundColor = .white
//                    reusableAdCell.layer.masksToBounds = false
//                    reusableAdCell.layer.cornerRadius = 2.0
//                    reusableAdCell.layer.shadowColor = UIColor.black.cgColor
//                    reusableAdCell.layer.shadowOffset = CGSize.init(width: 0, height: 1)
//                    reusableAdCell.layer.shadowRadius = 1.5
//                    reusableAdCell.layer.shadowOpacity = 0.75
//                    return reusableAdCell
//                }
//                else
//                {
//
                    var cell : PeopleTableViewCell!
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.people) as? PeopleTableViewCell
                    if cell == nil {
                        cell = PeopleTableViewCell(style: .default, reuseIdentifier: CellIdentifire.people)
                    }
                    cell.selectionStyle = .none
                    
                    if myFollowersModel != nil {
                        
                        switch typeofFollowers.rawValue
                        {
                        case 0:
                            cell.displayFollowersNode(followersNode: myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row])
                            
                            break
                        case 1:
                            
                            cell.displayFollowersNode(followersNode: myFollowersModel.data.user.edgeFollow.edges[indexPath.row])
                            break
                        default:
                            break
                        }
                    }
                    
                    cell.imageOpenTapped { [weak self] (sender, object) in
                        
                        if self == nil
                        {
                            return
                        }
                        
                        if let controller : MyFollowersViewController = self?.getViewControllerFromSubView() as? MyFollowersViewController {
                            
                            switch self!.typeofFollowers.rawValue
                            {
                            case 0:
                                
                                let image : ImagePopUp = ImagePopUp.init(frame: self!.frame, placeholder: cell.imgIcon?.image, iImageEditorType: .follow, mediaData: (self?.myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row])!)
                                
                                image.showInView(self, animated: true)
                                
                                image.btnTapped(event: { (sender, object) in
                                    
                                    let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: (self?.myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row])!, placeholder: image.imgProfile.image!)
                                    
                                    controller.navigationController?.pushViewController(profileViewController, animated: true)
                                    image.removeAnimate()
                                })
                                
                                break
                            case 1:
                                
                                let image : ImagePopUp = ImagePopUp.init(frame: self!.frame, placeholder: cell.imgIcon?.image, iImageEditorType: .follow, mediaData: (self?.myFollowersModel.data.user.edgeFollow.edges[indexPath.row])!)
                                
                                image.showInView(self, animated: true)
                                
                                image.btnTapped(event: { (sender, object) in
                                    let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: (self?.myFollowersModel.data.user.edgeFollow.edges[indexPath.row])!, placeholder: image.imgProfile.image!)
                                    controller.navigationController?.pushViewController(profileViewController, animated: true)
                                    
                                    image.removeAnimate()
                                })
                                
                                break
                            default:
                                break
                            }
                            
                            
                        }
                    }
                    return cell
//                }
        
            case 1:
                
//                if let nativeExpressAdView = anyobject[indexPath.row] as? GADNativeExpressAdView
//                {
//                    let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.nativeCell,for: indexPath)
//                    for subview in reusableAdCell.contentView.subviews {
//                        subview.removeFromSuperview()
//                    }
//                    reusableAdCell.contentView.addSubview(nativeExpressAdView)
//                    nativeExpressAdView.center = reusableAdCell.contentView.center
//                    reusableAdCell.selectionStyle = .none
//                    reusableAdCell.backgroundColor = .white
//                    reusableAdCell.layer.masksToBounds = false
//                    reusableAdCell.layer.cornerRadius = 2.0
//                    reusableAdCell.layer.shadowColor = UIColor.black.cgColor
//                    reusableAdCell.layer.shadowOffset = CGSize.init(width: 0, height: 1)
//                    reusableAdCell.layer.shadowRadius = 1.5
//                    reusableAdCell.layer.shadowOpacity = 0.75
//
//                    return reusableAdCell
//                }
//                else
//                {
                    
                    var cell : PeopleTableViewCell!
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.people) as? PeopleTableViewCell
                    if cell == nil {
                        cell = PeopleTableViewCell(style: .default, reuseIdentifier: CellIdentifire.people)
                    }
                    cell.selectionStyle = .none
                    
                    if myFollowersModel != nil {
                        
                        switch typeofFollowers.rawValue
                        {
                        case 0:
                            cell.displayFollowersNode(followersNode: myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row])
                            
                            break
                        case 1:
                            
                            cell.displayFollowersNode(followersNode: myFollowersModel.data.user.edgeFollow.edges[indexPath.row])
                            break
                        default:
                            break
                        }
                    }
                    
                    cell.imageOpenTapped { [weak self] (sender, object) in
                        
                        if self == nil
                        {
                            return
                        }
                        
                        if let controller : MyFollowersViewController = self?.getViewControllerFromSubView() as? MyFollowersViewController {
                            
                            switch self!.typeofFollowers.rawValue
                            {
                            case 0:
                                
                                let image : ImagePopUp = ImagePopUp.init(frame: self!.frame, placeholder: cell.imgIcon?.image, iImageEditorType: .follow, mediaData: (self?.myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row])!)
                                
                                image.showInView(self, animated: true)
                                
                                image.btnTapped(event: { (sender, object) in
                                   
                                    let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge:  (self?.myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row])!, placeholder: image.imgProfile.image!)
                                    controller.navigationController?.pushViewController(profileViewController, animated: true)
                                    image.removeAnimate()
                                })
                                
                                break
                            case 1:
                                
                                let image : ImagePopUp = ImagePopUp.init(frame: self!.frame, placeholder: cell.imgIcon?.image, iImageEditorType: .follow, mediaData: (self?.myFollowersModel.data.user.edgeFollow.edges[indexPath.row])!)
                                
                                image.showInView(self, animated: true)
                                
                                image.btnTapped(event: { (sender, object) in
                                    let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: (self?.myFollowersModel.data.user.edgeFollow.edges[indexPath.row])!, placeholder: image.imgProfile.image!)
                                    controller.navigationController?.pushViewController(profileViewController, animated: true)
                                    
                                    image.removeAnimate()
                                })
                                
                                break
                            default:
                                break
                            }
                            
                            
                        }
                    }
                    
                    return cell
//                }
        
                
            default:
//                if isSmall == false
//                {
//                    if let nativeExpressAdView = anyobject[indexPath.row] as? GADNativeExpressAdView
//                    {
//                        let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.nativeCell,for: indexPath)
//                        for subview in reusableAdCell.contentView.subviews {
//                            subview.removeFromSuperview()
//                        }
//                        reusableAdCell.contentView.addSubview(nativeExpressAdView)
//                        nativeExpressAdView.center = reusableAdCell.contentView.center
//                        reusableAdCell.selectionStyle = .none
//                        reusableAdCell.backgroundColor = .white
//                        reusableAdCell.layer.masksToBounds = false
//                        reusableAdCell.layer.cornerRadius = 2.0
//                        reusableAdCell.layer.shadowColor = UIColor.black.cgColor
//                        reusableAdCell.layer.shadowOffset = CGSize.init(width: 0, height: 1)
//                        reusableAdCell.layer.shadowRadius = 1.5
//                        reusableAdCell.layer.shadowOpacity = 0.75
//
//                        return reusableAdCell
//                    }
//                }
//
                break
            }
        }
        else if isSmall == false
        {
//            if let nativeExpressAdView = anyobject[indexPath.row] as? GADNativeExpressAdView
//            {
//                let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.nativeCell,for: indexPath)
//                for subview in reusableAdCell.contentView.subviews {
//                    subview.removeFromSuperview()
//                }
//                reusableAdCell.contentView.addSubview(nativeExpressAdView)
//                nativeExpressAdView.center = reusableAdCell.contentView.center
//                reusableAdCell.selectionStyle = .none
//                reusableAdCell.backgroundColor = .white
//                reusableAdCell.layer.masksToBounds = false
//                reusableAdCell.layer.cornerRadius = 2.0
//                reusableAdCell.layer.shadowColor = UIColor.black.cgColor
//                reusableAdCell.layer.shadowOffset = CGSize.init(width: 0, height: 1)
//                reusableAdCell.layer.shadowRadius = 1.5
//                reusableAdCell.layer.shadowOpacity = 0.75
//
//                return reusableAdCell
//            }
        }
        return UITableViewCell.init()
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell: UIView? = tableView.cellForRow(at: indexPath)
        if cell is PeopleTableViewCell {
            if let cells : PeopleTableViewCell = cell as? PeopleTableViewCell {
                
                switch typeofFollowers.rawValue
                {
                case 0:
//                    if anyobject[indexPath.row] is GADNativeExpressAdView{
//                        // Ad Clicked
//                    }
//                    else
//                    {
                        if let controller : MyFollowersViewController = self.getViewControllerFromSubView() as? MyFollowersViewController
                        {
                            switch typeofFollowers.rawValue
                            {
                            case 0:
                                
                                let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row], placeholder: cells.imgIcon.image!)
                                controller.navigationController?.pushViewController(profileViewController, animated: true)
                                break
                            case 1:
                                
                                let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: myFollowersModel.data.user.edgeFollow.edges[indexPath.row], placeholder: cells.imgIcon.image!)
                                controller.navigationController?.pushViewController(profileViewController, animated: true)
                                
                                break
                            default:
                                break
                            }
                        }
//                    }
                    
                    
                    break
                case 1:
//                    if anyobject[indexPath.row] is GADNativeExpressAdView{
//                        // Ad Clicked
//                    }
//                    else
//                    {
                        if let controller : MyFollowersViewController = self.getViewControllerFromSubView() as? MyFollowersViewController
                        {
                            switch typeofFollowers.rawValue
                            {
                            case 0:
                                
                                let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: myFollowersModel.data.user.edgeFollowedBy.edges[indexPath.row], placeholder: cells.imgIcon.image!)
                                controller.navigationController?.pushViewController(profileViewController, animated: true)
                                break
                            case 1:
                                
                                let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: myFollowersModel.data.user.edgeFollow.edges[indexPath.row], placeholder: cells.imgIcon.image!)
                                controller.navigationController?.pushViewController(profileViewController, animated: true)
                                
                                break
                            default:
                                break
                            }
                        }
//                    }
                    
                    break
                default:
//                    if isSmall == false
//                    {
//                        if anyobject[indexPath.row] is GADNativeExpressAdView
//                        {
//
//                        }
//                    }
                    break
                }
            }
        }
    }
    
}

extension MyFollowersView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch typeofFollowers.rawValue
//        {
//        case 0:
//            if isSmall == false
//            {
//                if let tableItem = anyobject[indexPath.row] as? GADNativeExpressAdView
//                {
//                    let isAdLoaded = loadStateForAds[tableItem]
//                    return isAdLoaded == true ? adBigViewHeight : 0
//                }
//            }
//            else
//            {
//                if let tableItem = anyobject[indexPath.row] as? GADNativeExpressAdView
//                {
//                    let isAdLoaded = loadStateForAds[tableItem]
//                    return isAdLoaded == true ? adViewHeight : 0
//                }
//            }
//            
//            
//        case 1:
//            if isSmall == false
//            {
//                if let tableItem = anyobject[indexPath.row] as? GADNativeExpressAdView
//                {
//                    let isAdLoaded = loadStateForAds[tableItem]
//                    return isAdLoaded == true ? adBigViewHeight : 0
//                }
//            }
//            else
//            {
//                if let tableItem = anyobject[indexPath.row] as? GADNativeExpressAdView
//                {
//                    let isAdLoaded = loadStateForAds[tableItem]
//                    return isAdLoaded == true ? adViewHeight : 0
//                }
//            }
//        
//        default:
//            if isSmall == false
//            {
//                if let tableItem = anyobject[indexPath.row] as? GADNativeExpressAdView
//                {
//                    let isAdLoaded = loadStateForAds[tableItem]
//                    return isAdLoaded == true ? adBigViewHeight : 0
//                }
//            }
//            return UITableView.automaticDimension
//            
//        }
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
