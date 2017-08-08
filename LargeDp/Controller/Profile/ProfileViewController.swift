//
//  ProfileViewController.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 04/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus

class ProfileViewController: BaseViewController {
    
    // Mark: - Attributes -
    var profileView : ProfileView!
    var searchUser : SearchUser!
    var followers : FollowersEdge!
    var btnAdd : UIButton!
    var userProfileModel : UserProfileModel!
    
    // MARK: - Lifecycle -
    
    override init() {
        
        var username : String = " " // Don't remove blank space from username it may affect the UI in navigation view of profile.
        
        if let name : String = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.LoginUserName) as? String{
            username = name
            if let userProfile : UserProfileModel = AppUtility.getUserDefaultsCustomObjectForKey(UserDefaultKey.userprofilemodel) as? UserProfileModel{
                
                self.userProfileModel = userProfile
            }
            
        }
        
        profileView = ProfileView(frame:CGRect.zero)
        super.init(iView: profileView, andNavigationTitle: username)
        
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
    }
    
    init(searchUserModel : SearchUser,placeholder : UIImage) {
        
        var username : String = " "
        if searchUserModel.user != nil{
            username = searchUserModel.user.username
            username = username == "" ?  " " : username
        }
        
        profileView = ProfileView.init(searchUserModel: searchUserModel,placeholder : placeholder)
        super.init(iView: profileView, andNavigationTitle: username)
        searchUser = searchUserModel
        
        profileView.arrToDownload.add(profileView.searchUser)
        
        DownloadManager.shared.downloadFiles(arrURL: profileView.arrToDownload,isFavorite: 0)
        
        let navigationBarFont: UIFont? = UIFont(name: FontStyle.medium, size: 23.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.navigationTitle.value,NSFontAttributeName: navigationBarFont!] as [String : Any]
        
        
        
        self.loadViewControls()
        self.setViewlayout()
  
    }
    
    init(followersEdge : FollowersEdge,placeholder : UIImage)
    {
        var username : String = " "
        if followersEdge.node != nil
        {
            username = followersEdge.node.username
            username = username == "" ? " " : username
        }
        
        profileView = ProfileView.init(followersEdge: followersEdge,placeholder : placeholder)
        super.init(iView: profileView, andNavigationTitle: username)
        followers = followersEdge
        
        profileView.arrToDownload.add(followers)
        
        DownloadManager.shared.downloadFiles(arrURL: profileView.arrToDownload,isFavorite: 0)
        
        self.loadViewControls()
        self.setViewlayout()
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("ProfileView ViewController deinit called")
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if profileView != nil && profileView.superview != nil {
            profileView.removeFromSuperview()
            profileView = nil
        }
        SwiftEventBus.unregister(self, name: NotificationsName.SearchUserMediaPaggination)
        SwiftEventBus.unregister(self, name: NotificationsName.LoginUserMediaPaggination)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.executeTaskInMainThreadAfterDelay(0.5, completion: {
            self.profileView.viewAdd.requestBannerAd(rootController: self)
        })
       
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
   
    
    @objc private func btnAddTapped(sender : UIButton) {
       
        if self.btnAdd.isSelected == true{
            var modelid = ""
            if self.searchUser != nil
            {
               modelid = self.searchUser.user.pk
            }
            else if self.followers != nil
            {
               modelid = self.followers.node.id
            }
            
            do{
                try DatabaseManager.sharedInstance.removeAddedCollection(collectionId: modelid, completion: { [weak self] (isSuccess) in
                    if self == nil{
                        return
                    }
                    if isSuccess == true{
                        self?.profileView.displayBottomToast(message: "removeimage".localize())
                        self?.btnAdd.isSelected = false
                    }
                })
            }
            catch let error as NSError{
                print(error.localizedDescription)
            }
        }
        else
        {
            self.btnAdd.isSelected = true
            if self.searchUser != nil
            {
                profileView.arrToDownload.add(searchUser)
                
                DownloadManager.shared.downloadFiles(arrURL: profileView.arrToDownload,isFavorite: 1)
                profileView.displayBottomToast(message: "successimage".localize())
            }
            else if self.followers != nil
            {
                profileView.arrToDownload.add(followers)
                
                DownloadManager.shared.downloadFiles(arrURL: profileView.arrToDownload,isFavorite: 1)
                profileView.displayBottomToast(message: "successimage".localize())
            }
            else{
                self.btnAdd.isSelected = false
            }
        }
    
    }
    // MARK: - Internal Helpers -
    
   
    
    
    // MARK: - Server Request -
    
}
