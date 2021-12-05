//
//  HomeView.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 04/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire
import SwiftEventBus
import GRDB
import Font_Awesome_Swift

class HomeView: BaseView {
    
    // Mark: - Attributes -
    var viewAdd : BaseAddBannerView!
    var viewContant : UIView!
    var txtSearch : BaseTextField!
    var btnSearch : BaseButton!
    var collectionView : UICollectionView!
    var btnSearchTouchUp : ControlTouchUpInsideEvent!
//    var personsController: FetchedRecordsController<myCollection>!
    private var cancellable: DatabaseCancellable?
        
    var clearAll : BaseButton!
    var lblRecentSearch : BaseLabel!
    var lblTitle : BaseLabel!
    var lblDetail : BaseLabel!
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func releaseObject() {
        super.releaseObject()
        SwiftEventBus.unregister(self)
       
        if viewAdd != nil && viewAdd.superview != nil {
            viewAdd.removeFromSuperview()
            //viewAdd = nil
        }
        if viewContant != nil && viewContant.superview != nil {
            viewContant.removeFromSuperview()
            viewContant = nil
        }
        if txtSearch != nil && txtSearch.superview != nil {
            txtSearch.removeFromSuperview()
            txtSearch = nil
        }
        if btnSearch != nil && btnSearch.superview != nil {
            btnSearch.removeFromSuperview()
            btnSearch = nil
        }
        if collectionView != nil && collectionView.superview != nil {
            collectionView.removeFromSuperview()
            collectionView = nil
        }
//        if personsController != nil
//        {
//            personsController = nil
//        }
        if clearAll != nil && clearAll.superview != nil
        {
            clearAll.removeFromSuperview()
            clearAll = nil
        }
        if lblTitle != nil && lblTitle.superview != nil
        {
            lblTitle.removeFromSuperview()
            lblTitle = nil
        }
        if lblDetail != nil && lblDetail.superview != nil
        {
            lblDetail.removeFromSuperview()
            lblDetail = nil
        }
        
        if lblRecentSearch != nil && lblRecentSearch.superview != nil
        {
            lblRecentSearch.removeFromSuperview()
            lblRecentSearch = nil
        }
        
       // btnSearchTouchUp = nil

    }
    
    deinit {
        print("HomeView Deinit called")
        self.releaseObject()
       
    }
    
    // MARK: - Layout -
    
    
    override func loadViewControls() {
        super.loadViewControls()
        self.backgroundColor = Color.appSecondaryBG.value
      
        viewContant = UIView(frame: .zero)
        viewContant.translatesAutoresizingMaskIntoConstraints = false
        viewContant.backgroundColor = .clear
        self.addSubview(viewContant)
        
        lblTitle = BaseLabel(labelType: .large, superView: viewContant)
        lblTitle.text = "hometitle".localize()
        
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont(name: FontStyle.bold, size: SystemConstants.IS_IPAD ? 26.0 : 20.0)
        
        lblDetail = BaseLabel(labelType: .small, superView: viewContant)
        lblDetail.numberOfLines = 0
        lblDetail.text = "homesubtitle".localize()
        
        lblDetail.textAlignment = .center
        lblDetail.font = UIFont(name: FontStyle.regular, size: SystemConstants.IS_IPAD ? 18.0 : 12.0)
        
        txtSearch = BaseTextField(iSuperView: viewContant, TextFieldType: .noAutoScroll)
        txtSearch.returnKeyType = UIReturnKeyType.search
        txtSearch.delegate = self
        txtSearch.placeholder = "homesearch".localize()
       
        lblRecentSearch = BaseLabel(labelType: .large, superView: viewContant)
        lblRecentSearch.text = "homerecent".localize()
        
        lblRecentSearch.textAlignment = .left
        lblRecentSearch.textColor = Color.sideMenuText.value
        lblRecentSearch.isHidden = true
        
        btnSearch = BaseButton.init(ibuttonType: .primary, iSuperView: viewContant)
        btnSearch.setTitle("searchplacehlder".localize(), for: .normal)
        btnSearch.setButtonTouchUpInsideEvent { [weak self] (sender, object) in
            if self == nil
            {
                return
            }
            
            self?.endEditing(true)
            
            if !(self?.txtSearch.text!.trimmingCharacters(in: .whitespaces).isEmpty)!
            {
                let aString = self?.txtSearch.text!.trimmingCharacters(in: .whitespaces)
                let newString = aString?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                
                if self!.btnSearchTouchUp != nil
                {
                    self!.btnSearchTouchUp("search" as AnyObject,newString as AnyObject)
                }
                
            }
            else
            {
                self?.displayBottomToast(message: "searchValidation".localize())
                
            }
           
            
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        clearAll = BaseButton.init(ibuttonType: BaseButtonType.transparent, iSuperView: viewContant)
        clearAll.tintColor = UIColor.white
        clearAll.setImage(UIImage(named:"closed"), for: .normal)
        clearAll.setTitleColor(UIColor.white, for: .normal)
        clearAll.setTitle("homeClearAll".localize(), for: .normal)
      
        clearAll.backgroundColor = Color.buttonPrimaryBG.value
        clearAll.addTarget(self, action: #selector(onClearClick), for: .touchUpInside)
      
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        viewContant.addSubview(collectionView)
        collectionView.register(PhotoCollectionViewcell.self, forCellWithReuseIdentifier : CellIdentifire.photoCollection)
       
//        viewAdd = BaseAddBannerView(adSize: kGADAdSizeBanner, bannerKey: InAddvertise.KAddBannerKey)
//        self.addSubview(viewAdd)
//        self.bringSubviewToFront(viewAdd)
        
        let observation = ValueObservation.tracking(myCollection.fetchAll)
//        cancellable = observation.start(
//            in: dbQueue,
//            scheduling: .immediate, // <- immediate scheduler
//            onError: { error in ... },
//            onChange: { [weak self] (players: [Player]) in
//                guard let self = self else { return }
//                self.updateView(players)
//            })
//
//        do{
//
//            personsController = try FetchedRecordsController.init(DatabaseManager.sharedInstance.dbQueue, sql: "SELECT * from myCollection where  isFavorite = 0 ORDER BY timestamp DESC")
//
//            personsController.trackChanges(willChange: { (_) in
//            }, onChange: { (controller, record, change) in
//                switch change{
//
//                case .insertion(_):
//                    self.collectionView.reloadData()
//                    break
//                case .deletion(_):
//                    self.collectionView.reloadData()
//                    break
//                case .update(_, changes: _):
//                    self.collectionView.reloadData()
//                    break
//                case .move(_):
//                    self.collectionView.reloadData()
//                    break
//                }
//            }) { (_) in
//                //self.tblCamList.endUpdates()
//            }
//
//            try personsController.performFetch()
//        }
//        catch let error as NSError{
//            print(error.localizedDescription)
//        }
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        self.baseLayout.viewDictionary = ["lblTitle" :lblTitle,
                                          "lblDetail" :lblDetail,
                                          "viewContant" : viewContant,
                                          "txtSearch" : txtSearch,
                                          "collectionView" : collectionView,
                                          "btnSearch" : btnSearch,
                                          "clearAll" : clearAll,
                                          "lblRecentSearch" : lblRecentSearch]
        
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        let buttonhight : CGFloat = SystemConstants.IS_IPAD ? 35 : 30
        let buttonwidth : CGFloat = SystemConstants.IS_IPAD ? 150 : 100
        let collectionhight : CGFloat = SystemConstants.IS_IPAD ? 250 : 190
        let verticalPadding  : CGFloat = ControlLayout.verticalPadding
        let buttonrdias : CGFloat = SystemConstants.IS_IPAD ? 17.5 : 16
        
        self.baseLayout.metrics = ["secondaryVerticalPadding" : secondaryVerticalPadding,
                                   "buttonhight" : buttonhight,
                                   "buttonwidth" : buttonwidth,
                                   "verticalPadding" : verticalPadding,
                                   "collectionhight" : collectionhight,
                                   "buttonrdias" : buttonrdias
                                  ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContant]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContant]|", options: [.alignAllLeading, .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        //SearchTextfields
        baseLayout.position_CenterX = NSLayoutConstraint(item: txtSearch, attribute: .centerX, relatedBy: .equal, toItem: viewContant, attribute: .centerX, multiplier: 1.0, constant: 0)
        viewContant.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.size_Width = NSLayoutConstraint(item: txtSearch, attribute: .width, relatedBy: .equal, toItem: viewContant, attribute: .width, multiplier: 0.8, constant: 0)
        viewContant.addConstraint(baseLayout.size_Width)
       
        //collectionView
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_H)
      
        baseLayout.position_CenterX = NSLayoutConstraint(item: btnSearch, attribute: .centerX, relatedBy: .equal, toItem: viewContant, attribute: .centerX, multiplier: 1.0, constant: 0)
        viewContant.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.size_Width = NSLayoutConstraint(item: btnSearch, attribute: .width, relatedBy: .equal, toItem: viewContant, attribute: .width, multiplier: 0.41, constant: 0)
        viewContant.addConstraint(baseLayout.size_Width)
       
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-verticalPadding-[lblTitle]-verticalPadding-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-verticalPadding-[lblDetail]-verticalPadding-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[lblTitle]-20-[lblDetail]-15-[txtSearch]-verticalPadding-[btnSearch]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_V)
       
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-secondaryVerticalPadding-[lblRecentSearch]-[clearAll(buttonwidth)]-verticalPadding@751-|", options: [.alignAllBottom,.alignAllTop], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_H)

        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[btnSearch]-secondaryVerticalPadding-[clearAll(buttonhight)]-secondaryVerticalPadding-[collectionView(collectionhight)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        viewContant.addConstraints(baseLayout.control_V)
        
        self.layoutIfNeeded()
        self.layoutSubviews()
       
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            clearAll.imageEdgeInsets = UIEdgeInsets(top: 6,left: 115,bottom: 6,right: 10)
            clearAll.titleEdgeInsets = UIEdgeInsets(top: 2,left: -45,bottom: 0,right: 40)
        }
        else{
            clearAll.imageEdgeInsets = UIEdgeInsets(top: 6,left: 70,bottom: 6,right: 10)
            clearAll.titleEdgeInsets = UIEdgeInsets(top: 2,left: -30,bottom: 0,right: 30)
        }
        
        clearAll.roundCorner(buttonrdias)
       
        self.layoutIfNeeded()
        self.layoutSubviews()
        
        do {
            baseLayout.releaseObject()
        }

    }
    
    // MARK: - Public Interface -
    
    @objc func onClearClick()
    {
        do{
            try DatabaseManager.sharedInstance.removeAddedRecent(completion: { [weak self] (isSuccess) in
                if self == nil{
                    return
                }
                if isSuccess == true{
                    self?.displayBottomToast(message: "removeimage".localize())
                    
                }
            })
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Searver Request -
    
    public func SearchRequest(searchText : String)
    {
        operationQueue.addOperation { [weak self] in
            if self == nil{
                return
            }
          
            let SearchApiURL = "\(APIConstant.searchAll)\(searchText)"
            
            BaseAPICall.shared.getRequest(URL: SearchApiURL, Parameter: NSDictionary(), Task: APITask.Search, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(let object, _):
                    
                    self!.hideProgressHUD()
                    
                    let searchModel : SearchModel = object as! SearchModel
                    print(searchModel.users.count)
                    
                    break
                case .Error(let error):
                    
                    self!.hideProgressHUD()
                    AppUtility.executeTaskInMainQueueWithCompletion {
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
    
   
    // MARK: - Internal Helpers -
    
    func btnSearchTapped(event: @escaping ControlTouchUpInsideEvent) {
        btnSearchTouchUp = event
    }
    
    // MARK: - Server Request -
    
}

extension HomeView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension HomeView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if  personsController != nil && personsController.sections[section].numberOfRecords != 0
//        {
//            lblRecentSearch.isHidden = false
//            clearAll.isHidden = false
//            return personsController.sections[section].numberOfRecords
//        }
//        else
//        {
            lblRecentSearch.isHidden = true
            clearAll.isHidden = true
            return 0
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell : PhotoCollectionViewcell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifire.photoCollection, for: indexPath as IndexPath) as? PhotoCollectionViewcell
        
        if cell == nil {
            cell = PhotoCollectionViewcell(frame: CGRect.zero)
        }
        
        configure(cell!, at: indexPath)
       
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        cell.contentView.layoutSubviews()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    func configure(_ cell: PhotoCollectionViewcell, at indexPath: IndexPath) {
//        cell.configureddatawithModel(model: personsController.record(at: indexPath))
    }

}


extension HomeView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell: UIView? = collectionView.cellForItem(at: indexPath)
        if cell is PhotoCollectionViewcell {
//            if let cells : PhotoCollectionViewcell = cell as? PhotoCollectionViewcell {
//
//                let myCollection = self.personsController.record(at: indexPath)
//                let dic = myCollection.toDictionary()
//                if let data : String = dic["data"] as? String
//                {
//                    if let dicData : NSDictionary = data.dictionary()
//                    {
//                        var type : Int = -1
//                        if let modelType = dic["modelType"] as? Int
//                        {
//                            type = modelType
//                        }
//                        else if let modelType = dic["modelType"]  as? Int64{
//                            type = Int(modelType)
//                        }
//                        else if let modelType = dic["modelType"]  as? String{
//                            type = Int(modelType)!
//                        }
//
//                        switch type
//                        {
//
//                        case ImageEditorViewType.follow.rawValue:
//                             let followersEdge = FollowersEdge.init(fromDictionary: dicData as! [String : AnyObject])
//
//                             if let controller : HomeController = self.getViewControllerFromSubView() as? HomeController {
//                                self.endEditing(true)
//                                let profileViewController : ProfileViewController = ProfileViewController.init(followersEdge: followersEdge, placeholder: cells.imgPhoto.image!)
//
//                                controller.navigationController?.pushViewController(profileViewController, animated: true)
//                             }
//
//                           break
//
//                        case ImageEditorViewType.searchUser.rawValue:
//
//                            let searchUser = SearchUser.init(fromDictionary: dicData as! [String : AnyObject])
//
//                            if let controller : HomeController = self.getViewControllerFromSubView() as? HomeController {
//                                self.endEditing(true)
//                                let profileViewController : ProfileViewController = ProfileViewController.init(searchUserModel: searchUser, placeholder: cells.imgPhoto.image!)
//
//                                controller.navigationController?.pushViewController(profileViewController, animated: true)
//                            }
//                            break
//                        default:
//                            break
//                        }
//                    }
//                }
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeView : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return CGSize(width: 160, height: 190)
        }
        else{
            return CGSize(width: 120, height: 165)
        }
       
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}
