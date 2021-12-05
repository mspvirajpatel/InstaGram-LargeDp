//
//  SideMenuView.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 20/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus

class SideMenuView: BaseView {
    
    // MARK: - Attribute -
    internal var userProfileView : UIView!
    private var imgUser : BaseImageView!
    var lblUserRealName : BaseLabel!
    var lblUserName: BaseLabel!
    
    private var seperatorView : UIView!
    private var tblMenu : UITableView!
    private var btnlogin : BaseButton!
    
    internal var arrMenuData : NSMutableArray! = NSMutableArray()
    internal var selectedCell : IndexPath = IndexPath(item: 0, section: 0)
    internal var selectedMenu : Int = Menu.home.rawValue
    var userProfileModel : UserProfileModel!
    
    fileprivate var cellSelecteEvent : TableCellSelectEvent!
    
    // MARK: - Lifecycle -
    init(){
        super.init(frame: .zero)
        self.loadViewControls()
        self.setViewlayout()
        self.loadMenuData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imgUser != nil{
            imgUser.clipsToBounds = true
            imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        }
    }
    
    deinit{
        print("side menu deinit called")
        self.releaseObject()
    }
    
    override func releaseObject() {
        super.releaseObject()
        
        SwiftEventBus.unregister(self)
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        self.backgroundColor = Color.sideMenuBG.value
        
        userProfileView = UIView()
        userProfileView.layer .setValue("userProfileView", forKey: ControlLayout.name)
        userProfileView.translatesAutoresizingMaskIntoConstraints = false
        userProfileView.backgroundColor = UIColor.clear
        self.addSubview(userProfileView)
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileViewTappedEvent(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        userProfileView.addGestureRecognizer(tapGesture)
        
        btnlogin = BaseButton(ibuttonType: .transparent, iSuperView: userProfileView)
        btnlogin.backgroundColor = UIColor.clear
        btnlogin.isHidden = false
        
        btnlogin.setButtonTouchUpInsideEvent { [weak self] (sendor, object) in
            if self == nil{
                return
            }
            if self!.cellSelecteEvent != nil{
                self!.cellSelecteEvent(nil,Menu.login.rawValue as AnyObject)
            }
        }
        
        imgUser = BaseImageView(type: .defaultImg, superView: userProfileView)
        imgUser.layer .setValue("imgUser", forKey: ControlLayout.name)
        imgUser.backgroundColor = UIColor.white
        imgUser.isHidden = true
        
        seperatorView = UIView()
        seperatorView.layer .setValue("seperatorView", forKey: ControlLayout.name)
        seperatorView.backgroundColor = Color.sideMenuText.value
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(seperatorView)
        
        lblUserName = BaseLabel(labelType: .small, superView: userProfileView)
        lblUserName.layer .setValue("lblUserName", forKey: ControlLayout.name)
        lblUserName.text = ""
        lblUserName.textColor = Color.sideMenuText.value
        lblUserName.isHidden = true
        lblUserName.textAlignment = .left
        
        lblUserRealName = BaseLabel(labelType: .large, superView: userProfileView)
        lblUserRealName.layer .setValue("lblUserRealName", forKey: ControlLayout.name)
        lblUserRealName.text = ""
        lblUserRealName.textColor = Color.sideMenuText.value
        lblUserRealName.isHidden = true

        tblMenu = UITableView(frame: .zero, style: .grouped)
        tblMenu.layer .setValue("tblMenu", forKey: ControlLayout.name)
        tblMenu.translatesAutoresizingMaskIntoConstraints = false
        tblMenu.backgroundColor = UIColor.clear
        tblMenu.separatorStyle = .none
        tblMenu.cellLayoutMarginsFollowReadableWidth = false
        tblMenu.alwaysBounceVertical = false
        tblMenu.delegate = self
        tblMenu.dataSource = self
        tblMenu.tableFooterView = UIView(frame: .zero)
        tblMenu.register(LeftMenuCell.self, forCellReuseIdentifier: CellIdentifire.leftMenuCell)
        self.addSubview(tblMenu)
        
        SwiftEventBus.onMainThread(self, name: LocalNotification.loginEvent) { [weak self] (notification) in
            if self == nil{
                return
            }
            self?.selectedCell = IndexPath(item: 0, section: 0)
            self?.loadMenuData()
            if let userName : String = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.LoginUserName) as? String{
                self?.getUserDetailsRequest(userName: userName,isLoadingShow : true)
            }
        }
       
        if let name : String = AppUtility.getUserDefaultsObjectForKey(UserDefaultKey.LoginUserName) as? String{
           
            if let userProfile : UserProfileModel = AppUtility.getUserDefaultsCustomObjectForKey(UserDefaultKey.userprofilemodel) as? UserProfileModel{
                
                self.userProfileModel = userProfile
                if self.userProfileModel.user != nil
                {
              
                    self.imgUser.displayImageFromURL((self.userProfileModel.user.profilePicUrlHd)!, placeholder: UIImage(named: "profileplaceholder"))
                    if self.userProfileModel.user.fullName != ""
                    {
                        self.lblUserRealName.text = self.userProfileModel.user.fullName
                    }
                    else
                    {
                        self.lblUserRealName.text = self.userProfileModel.user.username!
                    }
                    
                
                    self.lblUserName.text =  "@\(self.userProfileModel.user.username!)"
                    
                }
                self.showProfileView()
            }
            self.getUserDetailsRequest(userName: name,isLoadingShow : false)
        }
        else
        {
            self.showLoginView()
        }
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        baseLayout.metrics = ["hSpace" : ControlLayout.horizontalPadding, "vSpace" : ControlLayout.verticalPadding / 2]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[userProfileView]|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[userProfileView]-[seperatorView(==1)][tblMenu]|", options: [.alignAllLeading,.alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.expandView(btnlogin, insideView: userProfileView)
        
        // UserProfile View Constraint
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-vSpace-[imgUser]-vSpace-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-hSpace-[imgUser]-hSpace-[lblUserName]-hSpace-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        userProfileView.addConstraints(baseLayout.control_H)
        userProfileView.addConstraints(baseLayout.control_V)
        
        lblUserRealName.bottomAnchor.constraint(equalTo: imgUser.centerYAnchor, constant: ControlLayout.verticalPadding / 2).isActive = true
        lblUserName.topAnchor.constraint(equalTo: imgUser.centerYAnchor, constant: ControlLayout.verticalPadding / 2).isActive = true
        
        lblUserRealName.leadingAnchor.constraint(equalTo: lblUserName.leadingAnchor).isActive = true
        lblUserRealName.trailingAnchor.constraint(equalTo: lblUserName.trailingAnchor).isActive = true
        imgUser.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.20).isActive = true
        imgUser.heightAnchor.constraint(equalTo: imgUser.widthAnchor).isActive = true
        
        
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    // MARK: - Public Interface -
    open func updateUI(){
//        imgUser.layer.cornerRadius = (UIScreen.main.bounds.size.width * 0.15) / 2
//        imgUser.clipsToBounds = true
    }
    
    open func cellSelectedEvent( event : @escaping TableCellSelectEvent) -> Void{
        cellSelecteEvent = event
    }
    
    open func setSelectedMenu(type : Int) -> Void{
        
        selectedCell = IndexPath.init()
        
        for (section,item) in arrMenuData.enumerated(){
            for (index,menu) in ((item as! NSDictionary)["item"] as! NSArray).enumerated(){
                if (menu as! NSDictionary)["type"] as! Int == type{
                    selectedCell = IndexPath(row: index, section: section)
                }
            }
        }
        
        tblMenu.reloadData()
    }
    
    
    
    open func showLoginView(){
        self.btnlogin.isHidden = false
        self.imgUser.isHidden = false
        self.lblUserName.isHidden = false
        self.lblUserRealName.isHidden = false
        self.imgUser.image = UIImage(named: "App_icon")!
        self.lblUserName.text = "Login with Instagram"
        self.lblUserRealName.text = "LargeDp"
        
    }
    
    open func showProfileView(){
        self.btnlogin.isHidden = true
        self.imgUser.isHidden = false
        self.lblUserName.isHidden = false
        self.lblUserRealName.isHidden = false
    }
    
    open func loadMenuData(){
        
        arrMenuData.removeAllObjects()
        
        for menuData in PListManager().readFromPlist("Menu") as! NSMutableArray
        {
            let dicMenu : NSMutableDictionary = menuData as! NSMutableDictionary
            var arrItem : [NSDictionary] = []
            for item in dicMenu["item"] as! NSArray
            {
                switch  (item as! NSDictionary)["type"] as! Int{
                case Menu.logout.rawValue,Menu.profile.rawValue:
                    
                    if AppUtility.isSaveSessionId() == true{
                        arrItem.append(item as! NSDictionary)
                        self.showProfileView()
                    }
                    else
                    {
                        self.showLoginView()
                    }
                    break
                    
                case Menu.login.rawValue:
                    
                    if AppUtility.isSaveSessionId() == false{
                        arrItem.append(item as! NSDictionary)
                    }
                    break
                    
                default:
                    arrItem.append(item as! NSDictionary)
                    break
                }
            }
            dicMenu .setObject(arrItem, forKey: "item" as NSCopying)
            arrMenuData.add(dicMenu)
        }
        tblMenu.reloadData()
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    @objc fileprivate func profileViewTappedEvent(gesture : UITapGestureRecognizer) -> Void{
        if AppUtility.isSaveSessionId() == true{
//            if self.cellSelecteEvent != nil{
//                self.cellSelecteEvent(nil,Menu.profile.rawValue as AnyObject)
//            }
        }
    }
    
    fileprivate func getDataForCell(indexPath : IndexPath) -> NSDictionary{
        var dicMenu : NSDictionary! = arrMenuData[indexPath.section] as! NSDictionary
        var arrItem : NSArray! = dicMenu["item"] as! NSArray
        
        defer {
            dicMenu = nil
            arrItem = nil
        }
        return arrItem[indexPath.row] as! NSDictionary
    }
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
    func getUserDetailsRequest(userName : String,isLoadingShow : Bool) {
        
        let urlString : String! = "\(userName)/?__a=1"
        
        BaseAPICall.shared.getRequest(URL: urlString, Parameter: NSDictionary(), Task: APITask.UserProfile) { [weak self]  (result) in
            if self == nil
            {
                return
            }
            switch result{
            case .Success(let object, _):
                self!.hideProgressHUD()
                
                if object is UserProfileModel
                {
                    self?.userProfileModel = object as! UserProfileModel
                    AppUtility.setUserDefaultsCustomObject((self?.userProfileModel)!, forKey: "userprofilemodel")
                    if self?.userProfileModel.user != nil
                    {
                        self!.imgUser.displayImageFromURL((self?.userProfileModel.user.profilePicUrlHd)!, placeholder: UIImage(named: "profileplaceholder"))
                        if self?.userProfileModel.user.fullName != ""
                        {
                            self!.lblUserRealName.text = self!.userProfileModel.user.fullName!
                        }
                        else
                        {
                            self!.lblUserRealName.text = self!.userProfileModel.user.username!
                        }
                        self!.lblUserName.text =  "@\(self!.userProfileModel.user.username!)"
                       
                    }
                   
                }
                
                self!.showProfileView()
                break
                
            case .Error(let error):
                self!.hideProgressHUD()
                self!.isLoadedRequest = false
                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                    if self == nil {
                        return
                    }
                    self?.displayBottomToast(message: error!.serverMessage)
                }
                break
                
            case .Internet(let isOn):
                self!.isLoadedRequest = isOn
                self!.handleNetworkCheck(isAvailable: isOn, viewController: self!.userProfileView, showLoaddingView: isLoadingShow)
                break
            }
            
        }
    }
}

// MARK : Extension
// TODO : UITableView Delegate
extension SideMenuView : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellData : NSDictionary = self.getDataForCell(indexPath: indexPath)
        
        if self.cellSelecteEvent != nil{
            self.cellSelecteEvent(nil,cellData["type"] as AnyObject)
        }
    }
}

// TODO : UITableView DataSource
extension SideMenuView : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrMenuData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dicMenu : NSDictionary = arrMenuData[section] as! NSDictionary
        let arrItem : NSArray = dicMenu["item"] as! NSArray
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : LeftMenuCell!
        cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.leftMenuCell) as? LeftMenuCell
        
        if cell == nil
        {
            cell = LeftMenuCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifire.leftMenuCell)
        }
        
        let cellData : NSDictionary = self.getDataForCell(indexPath: indexPath)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.lblMenuText?.font = currentDevice.isIpad ? UIFont(name: FontStyle.bold, size: 16.0) : UIFont(name: FontStyle.bold, size: 16.0)
        
        if indexPath == selectedCell
        {
            cell.lblMenuText.textColor = Color.sideMenuSelectedText.value
            if let image = UIImage(named: cellData["icon"] as! String) {
                cell.imgIcon.image = image.maskWithColor(Color.sideMenuSelectedText.value)
                cell.backgroundColor = Color.sideMenuText.value
            }
        }
        else
        {
            cell.lblMenuText?.textColor = Color.sideMenuText.value
            if let image = UIImage(named: cellData["icon"] as! String) {
                cell.imgIcon.image = image.maskWithColor(Color.sideMenuText.value)
                cell.backgroundColor = UIColor.clear
            }
        }
        
        cell.lblMenuText?.text = (cellData["title"] as? String)?.localize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        
        let lbltext : UILabel = UILabel(frame: CGRect(x: 10, y:5, width: headerView.bounds.size.width, height: 20))
        lbltext.font = SystemConstants.IS_IPAD ? UIFont(name: FontStyle.bold, size: 21.0) : UIFont(name: FontStyle.bold, size: 18.0)
        lbltext.textColor = Color.sideMenuText.value
        lbltext.text = ((arrMenuData[section] as! NSDictionary)["title"] as? String)?.localize()
        headerView.addSubview(lbltext)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}
