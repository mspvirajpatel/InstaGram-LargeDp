//
//  ProfileView.swift
//  InstaLargerDp
//
//  Created by WebMobTech-3 on 04/04/17.
//  Copyright © 2017 WebMobTech-3. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire
import SwiftEventBus

class ProfileView: BaseView,GADInterstitialDelegate  {
    
    // Mark: - Attributes -
    var viewAdd : BaseAddBannerView!
    var viewContant : UIView!
    var buttonsContant : UIView!
    var displayContant : UIView!
    
    var itemsToShare = [AnyObject]()
    
    var interstitial : GADInterstitial!
    
    var lblUser : BaseLabel!
    var lblDetail : BaseLabel!
    var lblLink : BaseLabel!
    var lblFolowDetail : BaseLabel!
    
    var imgProfile : BaseImageView!
    var btnDownload : BaseButton!
    var btnRepost : BaseButton!
    var btnAddFav : BaseButton!
   
    var isVarified : BaseImageView!
   
    var placeholders : UIImage?

    var privacyView : UIView!
    var privacyIcon : UIImageView!
    var lblPrivacyMsg : BaseLabel!
    
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    
    var anyData :AnyObject!
    
    var editorType : ImageEditorViewType!
    
    var userProfileModel : UserProfileModel!
    var followerdetails : FollowersEdge!
    var searchUser : SearchUser!
    
    var arrToDownload : NSMutableArray = NSMutableArray()
    var isAPIRunning: Bool = false
    var isProfileVisible : Bool = true
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
        self.displayUserModel()
      
    }
    
    init(searchUserModel : SearchUser,placeholder : UIImage) {
        
        super.init(frame: CGRect.zero)
        searchUser = searchUserModel
        placeholders = placeholder
        self.loadViewControls()
        self.setViewlayout()
        self.DisplaySearchUserModel(searchUserModel: searchUserModel)
        
    }
    
    init(followersEdge : FollowersEdge,placeholder : UIImage) {
        
        super.init(frame: CGRect.zero)
        placeholders = placeholder
        followerdetails = followersEdge
        self.loadViewControls()
        self.setViewlayout()
        self.DisplayFollowerModel(followersEdge: followersEdge)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    deinit {
        print("ProfileView Deinit called")
        self.releaseObject()
      
    }
    
    // MARK: - Layout -
    
    override func releaseObject() {
        super.releaseObject()
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if viewContant != nil && viewContant.superview != nil {
            viewContant.removeFromSuperview()
            viewContant = nil
        }
        if viewAdd != nil && viewAdd.superview != nil {
            viewAdd.removeFromSuperview()
            //viewAdd = nil
        }
        if isVarified != nil && isVarified.superview != nil {
            isVarified.removeFromSuperview()
            isVarified = nil
        }
        
        userProfileModel = nil
    }
    
    override func loadViewControls()
    {
        super.loadViewControls()
        
        self.backgroundColor = Color.appSecondaryBG.value
        viewAdd = BaseAddBannerView(adSize: kGADAdSizeBanner, bannerKey: InAddvertise.KAddBannerKey)
        self.addSubview(viewAdd)
        
        viewContant = UIView(frame: .zero)
        viewContant.translatesAutoresizingMaskIntoConstraints = false
        viewContant.backgroundColor = Color.appSecondaryBG.value
        self.addSubview(viewContant)
       
        buttonsContant = UIView(frame: .zero)
        buttonsContant.translatesAutoresizingMaskIntoConstraints = false
        buttonsContant.backgroundColor = Color.appSecondaryBG.value
        self.addSubview(buttonsContant)
        
        displayContant = UIView(frame: .zero)
        displayContant.translatesAutoresizingMaskIntoConstraints = false
        displayContant.backgroundColor = Color.appSecondaryBG.value
        self.addSubview(displayContant)
        
        imgProfile = BaseImageView(type: BaseImageViewType.defaultImg, superView: viewContant)
        imgProfile.isUserInteractionEnabled = true
        imgProfile.setupForImageViewer()
        
        btnDownload = BaseButton(ibuttonType: .transparent, iSuperView: buttonsContant)
        btnDownload.setImage(UIImage(named: "rateUs")?.maskWithColor(Color.segmentSelectedBG.value), for: .normal)
        btnDownload.setImage(UIImage(named: "FillStar")?.maskWithColor(Color.segmentSelectedBG.value), for: .selected)
        btnDownload.setButtonTouchUpInsideEvent { [weak self] (sender, object) in
            
            if self == nil
            {
                return
            }
            if let controller : BaseViewController = self?.getViewControllerFromSubView() as? BaseViewController
            {
                self?.interstitial.present(fromRootViewController: controller)
            }
            
            if self?.btnDownload.isSelected == true{
                var modelid = ""
                if self?.searchUser != nil
                {
                    modelid = (self?.searchUser.user.pk)!
                }
                else if self?.followerdetails != nil
                {
                    modelid = (self?.followerdetails.node.id)!
                }
                
                do{
                    try DatabaseManager.sharedInstance.removeAddedCollection(collectionId: modelid, completion: { [weak self] (isSuccess) in
                        if self == nil{
                            return
                        }
                        if isSuccess == true{
                            SwiftEventBus.post("reloadCollection")
                            self?.displayBottomToast(message: "removeimage".localize())
                            self?.btnDownload.isSelected = false
                        }
                    })
                }
                catch let error as NSError{
                    print(error.localizedDescription)
                }
            }
            else
            {
                self?.btnDownload.isSelected = true
                if self?.searchUser != nil
                {
                    self?.arrToDownload.add((self?.searchUser)!)
                
                    DownloadManager.shared.downloadFiles(arrURL: (self?.arrToDownload)!,isFavorite: 1)
                    SwiftEventBus.post("reloadCollection")
                    self?.displayBottomToast(message: "successimage".localize())
                    
                }
                else if self?.followerdetails != nil
                {
                    self?.arrToDownload.add((self?.followerdetails)!)
                    
                    DownloadManager.shared.downloadFiles(arrURL: (self?.arrToDownload)!,isFavorite: 1)
                    SwiftEventBus.post("reloadCollection")
                    self?.displayBottomToast(message: "successimage".localize())
                }
                
                else{
                    self?.btnDownload.isSelected = false
                }
            }
            
        }
        btnRepost = BaseButton(ibuttonType: .transparent, iSuperView: buttonsContant)
        btnRepost.setImage(UIImage(named: "share")?.maskWithColor(Color.segmentSelectedBG.value), for: .normal)
        btnRepost.setImage(UIImage(named: "share")?.maskWithColor(Color.segmentSelectedBG.value), for: .selected)
        btnRepost.setButtonTouchUpInsideEvent { [weak self] (object, sender) in
            if self == nil {
                return
            }
            
            UIPasteboard.general.string = "InstaLargerDp"
            self?.itemsToShare = [AnyObject]()
            
            if self?.searchUser != nil
            {
                self?.itemsToShare.append(self?.imgProfile.image as AnyObject)
            }
            else if self?.followerdetails != nil
            {
                self?.itemsToShare.append(self?.imgProfile.image as AnyObject)
            }
            else{
                self?.itemsToShare.append("InstaLargerDp" as AnyObject)
            }
            
            let activityViewController = UIActivityViewController(activityItems: (self?.itemsToShare)!, applicationActivities: nil)
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                 activityViewController.popoverPresentationController!.sourceView = self?.btnRepost
            }
            else{
                 activityViewController.popoverPresentationController!.sourceView = self
            }
           
           
            if let controller : ProfileViewController = self!.getViewControllerFromSubView() as? ProfileViewController {
                            controller.navigationController?.present(activityViewController, animated: true, completion: nil)
                
            }
        }
        
        
        btnAddFav = BaseButton(ibuttonType: .transparent, iSuperView: buttonsContant)
        btnAddFav.setTitle("addtoCollectionbtn".localize(), for: .normal)
        btnAddFav.setImage(UIImage(named: "rateUs")?.maskWithColor(.black), for: .normal)
        btnAddFav.setImage(UIImage(named: "rateUs")?.maskWithColor(Color.segmentSelectedBG.value), for: .selected)
        btnAddFav.isHidden = true
        
        // Privacy View Constraint
        privacyView = UIView()
        privacyView.translatesAutoresizingMaskIntoConstraints = false
        privacyView.backgroundColor = UIColor.clear
        privacyView.isHidden = true
        displayContant.addSubview(privacyView)
        
        privacyIcon  = UIImageView(image: UIImage(named : "PrivacyIcon"))
        privacyIcon.translatesAutoresizingMaskIntoConstraints = false
        privacyView.contentMode = .scaleAspectFill
        privacyView.clipsToBounds = true
        displayContant.addSubview(privacyIcon)
        
        lblPrivacyMsg = BaseLabel(labelType: BaseLabelType.large, superView: displayContant)
        lblPrivacyMsg.text = "accountprivate".localize()
        
        lblUser = BaseLabel(labelType: .large, superView: displayContant)
        lblUser.text = ""
        lblUser.textAlignment = .center
        
        lblDetail = BaseLabel(labelType: .small, superView: displayContant)
        lblDetail.numberOfLines = 0
        lblDetail.text = ""
        lblDetail.textAlignment = .center
       
        isVarified = BaseImageView(type: BaseImageViewType.defaultImg, superView: displayContant)
        isVarified.isUserInteractionEnabled = true
        isVarified.image = UIImage(named : "VerifyUser")
        
        lblLink = BaseLabel(labelType: .small, superView: displayContant)
        lblLink.text = ""
        lblLink.textAlignment = .center
        
        lblFolowDetail = BaseLabel(labelType: .small, superView: displayContant)
        lblFolowDetail.text = ""
        lblFolowDetail.isHidden = true
        lblFolowDetail.textAlignment = .center
        
        self.createAndLoadInterstitial()
      
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        self.baseLayout.viewDictionary = ["viewAdd" : viewAdd,
                                          "viewContant" : viewContant,
                                          "privacyView" : privacyView,
                                          "privacyIcon" : privacyIcon,
                                          "lblPrivacyMsg" : lblPrivacyMsg,
                                          "lblUserName" : lblUser,
                                          "lblDetail" : lblDetail,
                                          "lblLink" : lblLink,
                                          "lblFolowDetail" : lblFolowDetail,
                                          "imgProfile" : imgProfile,
                                          "btnDownload" : btnDownload,
                                          "btnRepost" : btnRepost,
                                          "btnAddFav" : btnAddFav,
                                          "buttonsContant": buttonsContant,
                                          "displayContant" : displayContant,
                                          "isVarified" : isVarified]
        
        
        let horizontalPadding : CGFloat = ControlLayout.horizontalPadding
        let virticalPadding : CGFloat = ControlLayout.verticalPadding
        let secondaryHorizontalPadding : CGFloat = ControlLayout.secondaryHorizontalPadding
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        
        let AddViewHeight : CGFloat = SystemConstants.IS_IPAD ? 0 : 0
        let segmentHeight : CGFloat = SystemConstants.IS_IPAD ? 70 : 70
       
        let follwoImgHeight : CGFloat = SystemConstants.IS_IPAD ? 0 : 0
        
        self.baseLayout.metrics = ["horizontalPadding" : horizontalPadding,
                                   "virticalPadding" : virticalPadding,
                                   "secondaryHorizontalPadding" : secondaryHorizontalPadding,
                                   "secondaryVerticalPadding" : secondaryVerticalPadding,
                                   "AddViewHeight" : AddViewHeight,
                                   "segmentHeight" : segmentHeight
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewAdd]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[viewContant]-2-[buttonsContant]-2-[viewAdd]-5-[displayContant]-2-|", options: [.alignAllLeading, .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgProfile]|", options: [.alignAllLeading, .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_V)
        
        //TopHeaderView
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgProfile]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_H)
        
        baseLayout.size_Height = NSLayoutConstraint(item: imgProfile, attribute: .height, relatedBy: .equal, toItem: imgProfile, attribute: .width, multiplier: 0.78, constant: 0)
        viewContant.addConstraint(baseLayout.size_Height)
        

        //btnDownload
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalPadding-[btnDownload(30)]-10-[btnRepost(==btnDownload)]-10-[btnAddFav(==btnDownload)]", options:[.alignAllBottom,.alignAllTop], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        buttonsContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[btnDownload(30)]-2-|", options: [.alignAllLeading, .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        buttonsContant.addConstraints(baseLayout.control_V)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalPadding-[lblUserName]-horizontalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        displayContant.addConstraints(baseLayout.control_H)
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: lblDetail, attribute: .centerX, relatedBy: .equal, toItem: displayContant, attribute: .centerX, multiplier: 1.0, constant: 0)
        displayContant.addConstraint(baseLayout.position_CenterX)
     
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|->=0@100-[lblDetail]-5@251-[isVarified]->=0@100-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        displayContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalPadding-[lblLink]-horizontalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        displayContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalPadding-[privacyView]-horizontalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        displayContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[lblUserName]-3-[lblDetail]-3-[lblLink]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        displayContant.addConstraints(baseLayout.control_V)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[lblLink]-3-[privacyView]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        displayContant.addConstraints(baseLayout.control_V)
        
        // MARK : Privacy View Constraint
        
        baseLayout.size_Height = NSLayoutConstraint(item: isVarified, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 15)
        displayContant.addConstraint(baseLayout.size_Height)
        
        baseLayout.size_Width = NSLayoutConstraint(item: isVarified, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 15)
        displayContant.addConstraint(baseLayout.size_Width)
        
        privacyIcon.centerX(view: privacyView)
        privacyIcon.centerY(view: privacyView)
        privacyIcon.verticalSpace(view: lblPrivacyMsg, space: -10.0)
        lblPrivacyMsg.centerX(view: privacyIcon)
        
        displayContant.layoutIfNeeded()
        displayContant.layoutSubviews()
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        baseLayout.position_Top = NSLayoutConstraint(item: isVarified, attribute: .top, relatedBy: .equal, toItem: lblDetail, attribute: .top, multiplier: 1.0, constant: 0)
        displayContant.addConstraint(baseLayout.position_Top)
       
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        defer {
            baseLayout.releaseObject()
        }
    }
    
    // MARK: - Public Interface -
    
   
    // MARK: - User Interaction -
    func displayUserModel()  {
        if let _ : String = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.LoginUserName) as? String{
            
            if let userProfile : UserProfileModel = AppUtility.getUserDefaultsCustomObjectForKey(UserDefaultKey.userprofilemodel) as? UserProfileModel{
                
                self.userProfileModel = userProfile
                
                do
                {
                    if self.userProfileModel != nil
                    {
                        try DatabaseManager.sharedInstance.isCollectionAdded(collectionId: self.userProfileModel.user.id, completion: { (bool) in
                            btnDownload.isSelected = bool
                        })
                    }
                }
                catch let error as NSError {
                    print(error.description)
                    
                }
                
                if self.userProfileModel.user != nil
                {
                    self.imgProfile.displayImageFromURLWithPlaceholder((self.userProfileModel.user.profilePicUrlHd)!, placeholder: UIImage(named: "profileplaceholder"))
                    self.lblUser.text = self.userProfileModel.user.fullName
                    self.lblDetail.text = self.userProfileModel.user.biography
                    self.lblLink.text = self.userProfileModel.user.externalUrl
                }
                
                self.isAPIRunning = false
                
                if self.userProfileModel.user != nil && self.userProfileModel.user.media != nil && self.userProfileModel.user.followedBy != nil && self.userProfileModel.user.follows != nil
                {
                    
                }
                
                if self.userProfileModel.user != nil && self.userProfileModel.user.isPrivate == true
                {
                    self.viewContant.bringSubview(toFront: self.privacyView)
                    self.privacyView.isHidden = false
                    self.privacyIcon.isHidden = false
                    self.lblPrivacyMsg.isHidden = false
                    
                }
                else
                {
                    self.privacyIcon.isHidden = true
                    self.lblPrivacyMsg.isHidden = true
                    self.privacyView.isHidden = true
                }
                
            }
        }
    }
    
    
    func DisplayFollowerModel(followersEdge: FollowersEdge) {
        if followersEdge.node != nil && followersEdge.node.username != nil{
            
            if followersEdge.node != nil
            {
            
                self.imgProfile.displayImageFromURLWithPlaceholder((followersEdge.node.profilePicUrlHD)!, placeholder: placeholders)
                self.lblUser.text = followersEdge.node.fullName
                self.lblDetail.text = "@\(followersEdge.node.username!)"
                
                self.privacyView.isHidden = true
                self.privacyView.alpha = 0.0
                self.lblPrivacyMsg.isHidden = true
                self.lblPrivacyMsg.alpha = 0.0
                self.privacyIcon.isHidden = true
                self.privacyIcon.alpha = 0.0
                
                if followersEdge.node.isVerified == true
                {
                    isVarified.isHidden = false
                    
                }
                else
                {
                    isVarified.isHidden = true
                    
                    
                    
                }
                
            }
            
            do
            {
                if followersEdge.node != nil
                {
                    try DatabaseManager.sharedInstance.isCollectionAdded(collectionId: followersEdge.node.id, completion: { (bool) in
                        btnDownload.isSelected = bool
                    })
                }
            }
                
            catch let error as NSError {
                print(error.description)
                
            }
            
            self.isAPIRunning = false
            
            
            //self.userProfileRequest(userName: followerdetails.node.username!)
        }
    }
    
    
    func DisplaySearchUserModel(searchUserModel : SearchUser)  {
        if searchUserModel.user != nil{
            
            if searchUserModel.user != nil
            {
                self.imgProfile.displayImageFromURLWithPlaceholder((searchUserModel.user.profilePicUrlHD)!, placeholder: placeholders)
                self.lblUser.text = searchUserModel.user.fullName
                self.lblDetail.text = "@\(searchUserModel.user.username!)"
                self.lblLink.text = searchUserModel.user.byline
            }
            
            self.isAPIRunning = false
            
            do
            {
                if searchUserModel.user != nil
                {
                    try DatabaseManager.sharedInstance.isCollectionAdded(collectionId: searchUserModel.user.pk, completion: { (bool) in
                        btnDownload.isSelected = bool
                    })
                }
            }
            catch let error as NSError {
                print(error.description)
                
            }
            
            if searchUserModel.user != nil && searchUserModel.user.isPrivate == true
            {
                self.viewContant.bringSubview(toFront: self.privacyView)
                self.privacyView.isHidden = false
                self.privacyView.alpha = 1.0
                self.lblPrivacyMsg.isHidden = false
                self.lblPrivacyMsg.alpha = 1.0
                self.privacyIcon.isHidden = false
                self.privacyIcon.alpha = 1.0
                
            }
            else
            {
                self.privacyView.isHidden = true
                self.privacyView.alpha = 0.0
                self.lblPrivacyMsg.isHidden = true
                self.lblPrivacyMsg.alpha = 0.0
                self.privacyIcon.isHidden = true
                self.privacyIcon.alpha = 0.0
            }
            if searchUserModel.user != nil && searchUserModel.user.isVerified == true
            {
                isVarified.isHidden = false
            }
            else
            {
                isVarified.isHidden = true
                
            }
        }
    }
   
    // MARK: - Internal Helpers -
   
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID:InAddvertise.KAddFullscreen)
        
        if let isPremium : Bool = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.isPremiumUser) as? Bool
        {
            if !isPremium
            {
                let request : GADRequest! = GADRequest()
                //request.testDevices = [kGADSimulatorID]
                interstitial.load(request)
                interstitial.delegate = self
            }
        }
        else{
            let request : GADRequest! = GADRequest()
            //request.testDevices = [kGADSimulatorID]
            interstitial.load(request)
            interstitial.delegate = self
        }
    }
    
    // MARK: - Server Request -
    
    // TODO: - Full screen Add Delegates -
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Recieved ad : \(ad.adNetworkClassName!)")
    }
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("Error : \(error.description)")
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        self.createAndLoadInterstitial()
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        
    }

}
