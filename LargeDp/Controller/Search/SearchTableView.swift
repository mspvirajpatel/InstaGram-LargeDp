//
//  SearchTableView.swift
//  InstaLargeDp
//
//  Created by VirajPatel on 30/05/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus
//import GoogleMobileAds

class SearchTableView: BaseView {
    
    // Mark: - Attributes -
    var tableView : UITableView!
    var refreshControlSent : UIRefreshControl!
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    var peopleSearch : SearchModel!
    var searchText : String = ""
    private var isTextChange : Bool = false
    
//    var loadStateForAds : [GADNativeExpressAdView: Bool]! = [:]
//    var adsToLoad : [GADNativeExpressAdView]! = []
    var adViewHeight : CGFloat = SystemConstants.IS_IPAD ? 110 : 90
//    var adView = GADNativeExpressAdView()
    var adInterval = UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4
    var anyobject : NSMutableArray!
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("SearchTableView deinit called")
        self.releaseObject()
    }
    
    override func releaseObject() {
        super.releaseObject()
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if tableView != nil && tableView.superview != nil {
            tableView.removeFromSuperview()
            tableView = nil
        }
        if refreshControlSent != nil && refreshControlSent.superview != nil {
            refreshControlSent.removeFromSuperview()
            refreshControlSent = nil
        }
        
        btnTouchUpInside = nil
    }
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
        self.backgroundColor = UIColor.red
        refreshControlSent = UIRefreshControl()
        refreshControlSent.attributedTitle = NSAttributedString(string: "pullToRefresh".localize())
        refreshControlSent.addTarget(self, action: #selector(refreshList), for: UIControl.Event.valueChanged)
        
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.addSubview(refreshControlSent)
        self.addSubview(tableView)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: CellIdentifire.people)
        tableView.register(NativeAddCell.self, forCellReuseIdentifier: CellIdentifire.nativeCell)
        
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
    func searchPeople(query : String){
        if isLoadedRequest == false {
            isLoadedRequest = true
            self.searchUsersRequest(searchText: query)
        }
        else{
            isTextChange = false
        }
    }
    
    
    
    // MARK: - User Interaction -
    @objc func refreshList()
    {
        if searchText != ""{
            self.searchPeople(query: searchText)
        }
        else{
            self.refreshControlSent.endRefreshing()
        }
    }
    
    // MARK: - Internal Helpers -
    func btnTapped(event: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = event
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
//            peopleSearch.users.insert(SearchUser.init(fromDictionary: [:]), at: index)
//
//            index += adInterval
//            adsToLoad.append(adView)
//
//            self.loadStateForAds[adView] = true
//        }
        
    }

    
    
    // MARK: - Server Request -
    private func searchUsersRequest(searchText : String)
    {
        if operationQueue == nil{
            return
        }
        
        operationQueue.addOperation { [weak self] in
            if self == nil{
                return
            }
            var encodeText : String = searchText
            
            if let encode = encodeText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed){
                encodeText = encode
            }
            
            let SearchApiURL = "\(APIConstant.searchUserAll)\(encodeText)"
            
            BaseAPICall.shared.getRequest(URL: SearchApiURL, Parameter: NSDictionary(), Task: APITask.Search, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(let object,_):
                    self!.isLoadedRequest = false
                    self!.hideProgressHUD()
                    
                    if object is SearchModel
                    {
                        let searchModel : SearchModel = object as! SearchModel
                        
                        self!.peopleSearch = searchModel
                        self?.anyobject = NSMutableArray.init()
                        self?.anyobject.removeAllObjects()
                        self?.anyobject.addObjects(from: (self!.peopleSearch.users)!)
                        if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool
                        {
                            if !isPremium
                            {
                                self!.addNativeExpressAds()
                            }
                        }
                        
                        self!.tableView.reloadData()
                        InterfaceUtility.animateCellTableView(tableview: self!.tableView)
                    }
                    break
                case .Error(let error):
                    self!.isLoadedRequest = false
                    self!.hideProgressHUD()
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                        if self == nil {
                            return
                        }
                        self!.tableView.reloadData()
                        self?.displayBottomToast(message: error!.serverMessage)
                    }
                    
                    break
                case .Internet(let isOn):
                    self!.isLoadedRequest = isOn
                    
                    self!.handleNetworkCheck(isAvailable: isOn, viewController: self!, showLoaddingView: true)
                    break
                }
                self?.isTextChange = false
            })
            AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                if self == nil{
                    return
                }
                self!.refreshControlSent.endRefreshing()
            }
        }
    }
}

extension SearchTableView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if anyobject != nil && anyobject.count > 0{
            self.displayErrorMessageLabel("")
            self.errorMessageLabel.isHidden = true
            return anyobject.count
        }
        else if anyobject != nil && anyobject.count == 0
        {
            self.errorMessageLabel.textColor = Color.activeBarButtonText.value
            let fullString = NSMutableAttributedString(string:"No users Found".localize())
//            let image1Attachment = NSTextAttachment()
//            image1Attachment.image = UIImage(named: "BarButton_Save")?.maskWithColor(Color.sideMenuText.value)
//            let image1String = NSAttributedString(attachment: image1Attachment)
//            fullString.append(image1String)
            self.displayErrorAttributeMessageLabel(fullString)
            self.bringSubviewToFront((self.errorMessageLabel)!)
            self.errorMessageLabel.isHidden = false
            self.errorMessageLabel.alpha = 1
          
            return 0
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if peopleSearch != nil {
            
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
//                return reusableAdCell
//            }
//            else
//            {
                var cell : PeopleTableViewCell!
                cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.people) as? PeopleTableViewCell
                if cell == nil {
                    cell = PeopleTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifire.people)
                }
                
                if peopleSearch != nil {
                    
                    cell.displayUserContant(searchUser: peopleSearch.users[indexPath.row])
                }
                cell.selectionStyle = .none
                
                cell.imageOpenTapped { [weak self] (sender, object) in
                    
                    if self == nil
                    {
                        return
                    }
                    
                    if let controller : SearchViewController = self?.getViewControllerFromSubView() as? SearchViewController {
                        
                        let image : ImagePopUp = ImagePopUp.init(frame: self!.frame, placeholder: cell.imgIcon?.image, iImageEditorType: .searchUser, mediaData: (self!.peopleSearch.users[indexPath.row]))
                        
                        image.showInView(self, animated: true)
                        
                        image.btnTapped(event: { [weak self] (sender, object) in
                            
                            if self == nil{
                                return
                            }
                            
                            let profileViewController : ProfileViewController = ProfileViewController.init(searchUserModel: image.searchUser, placeholder: image.imgProfile.image!)
                            
                            controller.navigationController?.pushViewController(profileViewController, animated: true)
                            
                            image.removeAnimate()
                            
                        })
                    }
                }
                return cell
//            }
        }
        return UITableViewCell.init()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller : SearchViewController = self.getViewControllerFromSubView() as? SearchViewController {
            
            let cell: UIView? = tableView.cellForRow(at: indexPath)
            if cell is PeopleTableViewCell {
                if let cells : PeopleTableViewCell = cell as? PeopleTableViewCell {
                    let profileViewController : ProfileViewController = ProfileViewController.init(searchUserModel: peopleSearch.users[indexPath.row], placeholder: cells.imgIcon.image!)
                    
                    
                    controller.navigationController?.pushViewController(profileViewController, animated: true)
                    
                }
            }
        }
    }
    
}

extension SearchTableView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let tableItem = anyobject[indexPath.row] as? GADNativeExpressAdView
//        {
//            let isAdLoaded = loadStateForAds[tableItem]
//            return isAdLoaded == true ? adViewHeight : 0
//        }

        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
