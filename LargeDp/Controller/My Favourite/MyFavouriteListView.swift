//
//  PeopleListView.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 07/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus
import GRDB
//import GoogleMobileAds

class MyFavouriteListView: BaseView {
    
    // Mark: - Attributes -
    var tableView : UITableView!
    var refreshControlSent : UIRefreshControl!
    
    var adInterval = UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4
//    var loadStateForAds : [GADNativeExpressAdView: Bool]! = [:]
//    var adsToLoad : [GADNativeExpressAdView]! = []
    var adViewHeight : CGFloat = SystemConstants.IS_IPAD ? 110 : 90
//    var adView = GADNativeExpressAdView()
    var anyobject : NSMutableArray! = NSMutableArray()
    
    
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
        print("MyFavouriteListView deinit called")
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
       
       
    }
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
       
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
        tableView.sectionIndexBackgroundColor = .clear
       // tableView.addSubview(refreshControlSent)
        self.addSubview(tableView)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(PeopleTableViewCell.self, forCellReuseIdentifier: CellIdentifire.people)
        
        tableView.register(NativeAddCell.self, forCellReuseIdentifier: CellIdentifire.nativeCell)
         
        
    }
    
    func addNativeExpressAds() {
        
//        var index = adInterval
//        while index < anyobject.count {
//            let adSize = GADAdSizeFromCGSize(
//                CGSize(width: self.width - 10, height: adViewHeight))
//            self.adView = GADNativeExpressAdView(adSize: adSize)!
//
//            adView.adUnitID = InAddvertise.kNativeadd
//            if let controller : UIViewController = self.getViewControllerFromSubView(){
//                adView.rootViewController = controller
//                adView.load(GADRequest())
//            }
//
//            anyobject.insert(adView, at: index)
//            index += adInterval
//            adsToLoad.append(adView)
//
//            self.loadStateForAds[adView] = true
//        }

    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = ["tableView" : tableView]
        
        self.baseLayout.metrics = [:]
        
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
    
    
    // MARK: - User Interaction -
    @objc func refreshList()
    {
        self.refreshControlSent.endRefreshing()
    }
}

extension MyFavouriteListView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if anyobject != nil && anyobject.count != 0
        {
            self.errorMessageLabel.isHidden = true
            self.displayErrorMessageLabel("".localize())
            return anyobject.count
        }
        else
        {
            self.errorMessageLabel.textColor = Color.activeBarButtonText.value
            let fullString = NSMutableAttributedString(string:"noimagecolection".localize())
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "BarButton_Save")?.maskWithColor(Color.sideMenuText.value)
            let image1String = NSAttributedString(attachment: image1Attachment)
            fullString.append(image1String)
            self.displayErrorAttributeMessageLabel(fullString)
            self.bringSubviewToFront((self.errorMessageLabel)!)
            self.errorMessageLabel.isHidden = false
            self.errorMessageLabel.alpha = 1
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if anyobject != nil {
            
//            if let nativeExpressAdView = anyobject[indexPath.row] as? GADNativeExpressAdView
//            {
//                
//                let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.nativeCell,for: indexPath)
//                for subview in reusableAdCell.contentView.subviews {
//                    subview.removeFromSuperview()
//                }
//                reusableAdCell.contentView.addSubview(nativeExpressAdView)
//                nativeExpressAdView.center = reusableAdCell.contentView.center
//                
//                reusableAdCell.selectionStyle = .none
//                reusableAdCell.backgroundColor = .white
//                reusableAdCell.layer.masksToBounds = false
//                //innerView.layer.cornerRadius = 2.0
//                reusableAdCell.layer.shadowColor = UIColor.black.cgColor
//                reusableAdCell.layer.shadowOffset = CGSize.init(width: 0.5, height: 1)
//                reusableAdCell.layer.shadowRadius = 1.0
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
                
                cell.selectionStyle = .none
               
                if let profileNode : AnyObject = anyobject.get(indexPath.row) as AnyObject?
                {
                     cell.displayAllObjects(allFavUsers: profileNode )
                }
                
                cell.imageOpenTapped { [weak self] (sender, object) in
                    
                    if self == nil
                    {
                        return
                    }
                    
                    if let _ : MyFavouriteViewController = self?.getViewControllerFromSubView() as? MyFavouriteViewController {
                        let myCollection : myCollection = self!.anyobject.get(indexPath.row) as! myCollection
                      
                        let dic = myCollection.toDictionary()
                        
                        if let data : String = dic["data"] as? String
                        {
                            if let dicData : NSDictionary = data.dictionary()
                            {
                                var type : Int = -1
                                if let modelType = dic["modelType"] as? Int
                                {
                                    type = modelType
                                }
                                else if let modelType = dic["modelType"]  as? Int64{
                                    type = Int(modelType)
                                }
                                else if let modelType = dic["modelType"]  as? String{
                                    type = Int(modelType)!
                                }
                                
                                switch type
                                {
                                    
                                case ImageEditorViewType.follow.rawValue:
                                    let followersEdge = FollowersEdge.init(fromDictionary: dicData as! [String : AnyObject])
                                    
                                    let image : ImagePopUp = ImagePopUp.init(frame: self!.frame, placeholder: cell.imgIcon?.image, iImageEditorType: .follow, mediaData: followersEdge)
                                    
                                    image.showInView(self, animated: true)
                                    
                                    image.btnTapped(event: { [weak self] (sender, object) in
                                        
                                        if self == nil{
                                            return
                                        }
                                        
                                        if let controller : MyFavouriteViewController = self?.getViewControllerFromSubView() as? MyFavouriteViewController {
                                            
                                            let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: image.followersEdge,placeholder: image.imgProfile.image!)
                                            
                                            
                                            controller.navigationController?.pushViewController(profileViewController, animated: true)
                                            
                                            image.removeAnimate()
                                            
                                        }
                                        
                                    })
                                    
                                    break
                                    
                                case ImageEditorViewType.searchUser.rawValue:
                                    
                                    let searchUser = SearchUser.init(fromDictionary: dicData as! [String : AnyObject])
                                    
                                    let image : ImagePopUp = ImagePopUp.init(frame: self!.frame, placeholder: cell.imgIcon?.image, iImageEditorType: .searchUser, mediaData: searchUser)
                                    
                                    image.showInView(self, animated: true)
                                    
                                    image.btnTapped(event: { [weak self] (sender, object) in
                                        
                                        if self == nil{
                                            return
                                        }
                                        if let controller : MyFavouriteViewController = self?.getViewControllerFromSubView() as? MyFavouriteViewController {
                                            
                                            let profileViewController : ProfileViewController = ProfileViewController.init(searchUserModel: image.searchUser,placeholder: image.imgProfile.image!)
                                            
                                            controller.navigationController?.pushViewController(profileViewController, animated: true)
                                            
                                            image.removeAnimate()
                                        }
                                    })
                                    
                                    
                                    break
                                    
                                default:
                                    break
                                }
                            }
                        }
                    }
                }
                return cell
//            }
        }
        return UITableViewCell.init()
        
       
       
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        let cell: UIView? = tableView.cellForRow(at: indexPath)
        if cell is PeopleTableViewCell {
            if let cells : PeopleTableViewCell = cell as? PeopleTableViewCell {
                if let controller : MyFavouriteViewController = self.getViewControllerFromSubView() as? MyFavouriteViewController {
                    
                    let myCollection = anyobject.get(indexPath.row) as! myCollection
                    let dic = myCollection.toDictionary()
                    
                    if let data : String = dic["data"] as? String
                    {
                        if let dicData : NSDictionary = data.dictionary()
                        {
                            var type : Int = -1
                            if let modelType = dic["modelType"] as? Int
                            {
                                type = modelType
                            }
                            else if let modelType = dic["modelType"]  as? Int64{
                                type = Int(modelType)
                            }
                            else if let modelType = dic["modelType"]  as? String{
                                type = Int(modelType)!
                            }
                            
                            switch type
                            {
                                
                            case ImageEditorViewType.follow.rawValue:
                                let followersEdge = FollowersEdge.init(fromDictionary: dicData as! [String : AnyObject])
                                
                                let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: followersEdge,placeholder: cells.imgIcon.image!)
                                
                                controller.navigationController?.pushViewController(profileViewController, animated: true)
                                
                                break
                                
                            case ImageEditorViewType.searchUser.rawValue:
                                
                                let searchUser = SearchUser.init(fromDictionary: dicData as! [String : AnyObject])
                                
                                let profileViewController : ProfileViewController = ProfileViewController.init(searchUserModel: searchUser,placeholder: cells.imgIcon.image!)
                                
                                controller.navigationController?.pushViewController(profileViewController, animated: true)
                                
                                break
                                
                            default:
                                break
                            }
                        }
                    }
                }
            }
        }
        
    }
    
}

extension MyFavouriteListView : UITableViewDelegate {
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
