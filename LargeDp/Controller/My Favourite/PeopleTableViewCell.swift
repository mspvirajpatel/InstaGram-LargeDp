//
//  PeopleTableViewCell.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 07/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus

class PeopleTableViewCell: UITableViewCell {
    
    // MARK: - Attributes -
    var innerView : UIView!
    var imgIcon : BaseImageView!
    var lblTitle : BaseLabel!
    var lblSubTitle : BaseLabel!
    var lblfollowers : BaseLabel!
    var isVarified : BaseImageView!
    var lableContainer: UIView!
    var imgIsPrivate : BaseImageView!
    
    var constantAll : [NSLayoutConstraint]!
    var constanttitle : [NSLayoutConstraint]!
    var constanttitleSubtittle : [NSLayoutConstraint]!
    var constanttitleFOLLOWERS : [NSLayoutConstraint]!
    
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    
    // MARK: - Lifecycle -
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.loadViewControls()
        self.setViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    deinit {
        print("PeopleTableViewCell deinit called")
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if lblSubTitle != nil && lblSubTitle.superview != nil {
            lblSubTitle.removeFromSuperview()
            lblSubTitle = nil
        }
        if lblTitle != nil && lblTitle.superview != nil {
            lblTitle.removeFromSuperview()
            lblTitle = nil
        }
        if lblfollowers != nil && lblfollowers.superview != nil {
            lblfollowers.removeFromSuperview()
            lblfollowers = nil
        }
        if imgIcon != nil && imgIcon.superview != nil {
            imgIcon.removeFromSuperview()
            imgIcon = nil
        }
        if innerView != nil && innerView.superview != nil {
            innerView.removeFromSuperview()
            innerView = nil
        }
       
        if imgIsPrivate != nil && imgIsPrivate.superview != nil {
            imgIsPrivate.removeFromSuperview()
            imgIsPrivate = nil
        }
        if isVarified != nil && isVarified.superview != nil {
            isVarified.removeFromSuperview()
            isVarified = nil
        }
        if lableContainer != nil && lableContainer.superview != nil {
            lableContainer.removeFromSuperview()
            lableContainer = nil
        }

        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
       
        innerView.layer.masksToBounds = false
        //innerView.layer.cornerRadius = 2.0
        innerView.layer.shadowColor = UIColor.black.cgColor
        innerView.layer.shadowOffset = CGSize.init(width: 0.5, height: 1)
        innerView.layer.shadowRadius = 1.0
        innerView.layer.shadowOpacity = 0.75
        
    }
    
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted){
            self.contentView.backgroundColor = Color.cellBG.withAlpha(0.2)
        }else{
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Layout -
    
    func loadViewControls(){
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.clipsToBounds = false
        
        self.backgroundColor = UIColor.white
        self.clipsToBounds = false
        self.selectionStyle = .none
        
        innerView = UIView(frame: CGRect.zero)
        innerView.backgroundColor = UIColor.white
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(innerView)
        
        imgIcon = BaseImageView(type: .defaultImg, superView: innerView)
        imgIcon.contentMode = .scaleAspectFit
        imgIcon.layer.masksToBounds = true
        imgIcon.clipsToBounds = true
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgIcon.isUserInteractionEnabled = true
        imgIcon.addGestureRecognizer(tapGestureRecognizer)
        
        lableContainer = UIView(frame: CGRect.zero)
        lableContainer.backgroundColor = UIColor.white
        lableContainer.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(lableContainer)
        
        lblTitle = BaseLabel(labelType: .medium, superView: lableContainer)
        lblTitle.textAlignment = .left
        lblTitle.numberOfLines = 1
        lblTitle.font = UIFont(name: FontStyle.regular, size: SystemConstants.IS_IPAD ? 17.0 : 12.0)
        
        lblSubTitle = BaseLabel(labelType: .medium, superView: lableContainer)
        lblSubTitle.textAlignment = .left
        lblSubTitle.numberOfLines = 1
        lblSubTitle.font = UIFont(name: FontStyle.light, size: SystemConstants.IS_IPAD ? 13.0 : 10.0)
        
        lblfollowers = BaseLabel(labelType: .medium, superView: lableContainer)
        lblfollowers.textAlignment = .left
        lblfollowers.numberOfLines = 1
        lblfollowers.font = UIFont(name: FontStyle.regular, size: SystemConstants.IS_IPAD ? 17.0 : 12.0)
        
        imgIsPrivate = BaseImageView(type: .defaultImg, superView: self.contentView)
        imgIsPrivate.isHidden = true
        imgIsPrivate.image = UIImage(named: "PrivacyIcon")
        self.imgIsPrivate.alpha = 1
     
        isVarified = BaseImageView(type: BaseImageViewType.defaultImg, superView: lableContainer)
        isVarified.isUserInteractionEnabled = true
        isVarified.image = UIImage(named : "VerifyUser")
        isVarified.isHidden = true
    }
    
    func setViewLayout(){
        
        var layout : AppBaseLayout! = AppBaseLayout()
        
        layout.viewDictionary = ["innerView" : innerView,
                                 "imgIcon" : imgIcon,
                                 "lblTitle" : lblTitle,
                                 "lblSubTitle" : lblSubTitle,
                                 "imgIsPrivate" : imgIsPrivate,
                                 "isVarified" : isVarified,
                                 "lblfollowers" : lblfollowers,
                                 "lableContainer" : lableContainer]
        
        let horizontalPadding : CGFloat = ControlLayout.horizontalPadding
        let virticalPadding : CGFloat = ControlLayout.verticalPadding
        let secondaryHorizontalPadding : CGFloat = ControlLayout.secondaryHorizontalPadding
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        
        let constantIconHeight : CGFloat = SystemConstants.IS_IPAD ? 75 : 60
        
        
        layout.metrics = ["horizontalPadding" : horizontalPadding,
                          "virticalPadding" : virticalPadding,
                          "secondaryHorizontalPadding" : secondaryHorizontalPadding,
                          "secondaryVerticalPadding" : secondaryVerticalPadding,
                          "constantIconHeight" : constantIconHeight]
        
        
        
        //InnerView...
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[innerView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5@251-[innerView]-5@251-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_V)
        
        
        // ImageView...
        layout.size_Width = NSLayoutConstraint(item: imgIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: constantIconHeight)
        innerView.addConstraint(layout.size_Width)
        
        layout.size_Height = NSLayoutConstraint(item: imgIcon, attribute: .height, relatedBy: .equal, toItem: imgIcon, attribute: .width, multiplier: 1.0, constant: 0)
        innerView.addConstraint(layout.size_Height)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-virticalPadding-[imgIcon]-virticalPadding-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_V)
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-horizontalPadding-[imgIcon]-0-[lableContainer]-virticalPadding-|", options: [.alignAllCenterY], metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_H)
       
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lblTitle]-5@251-[isVarified]->=5@751-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        lableContainer.addConstraints(layout.control_H)
        
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lblSubTitle]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        lableContainer.addConstraints(layout.control_H)
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lblfollowers]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        lableContainer.addConstraints(layout.control_H)
        
        constantAll = NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[lblSubTitle]-2-[lblTitle]-2-[lblfollowers]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        lableContainer.addConstraints(constantAll)
        
        constanttitle = NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[lblTitle]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
       
        constanttitleSubtittle = NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[lblSubTitle]-2-[lblTitle]-2-|", options:NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        
        constanttitleFOLLOWERS = NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[lblTitle]-2-[lblfollowers]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
       
        layout.size_Height = NSLayoutConstraint(item: isVarified, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.0, constant: 15)
        lableContainer.addConstraint(layout.size_Height)
        
        layout.size_Width = NSLayoutConstraint(item: isVarified, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 15)
        lableContainer.addConstraint(layout.size_Width)
 
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[imgIsPrivate]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[imgIsPrivate]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_V)
        
        layout.size_Height = NSLayoutConstraint(item: imgIsPrivate, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 0.0, constant: 20)
        self.contentView.addConstraint(layout.size_Height)
        
        layout.size_Width = NSLayoutConstraint(item: imgIsPrivate, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0.0, constant: 20)
        self.contentView.addConstraint(layout.size_Width)
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }
            self!.imgIcon.layer.borderWidth = 0.0
            self!.imgIcon.layer.borderColor = Color.imageViewBorder.value.cgColor
            self!.imgIcon.layer.cornerRadius = self!.imgIcon.bounds.height / 2
        }
        innerView.layoutSubviews()
        innerView.layoutIfNeeded()
        self.layoutIfNeeded()
        self.layoutSubviews()
       
        layout.position_Top = NSLayoutConstraint(item: isVarified, attribute: .top, relatedBy: .equal, toItem: lblTitle, attribute: .top, multiplier: 1.0, constant: 0)
        lableContainer.addConstraint(layout.position_Top)
        
        defer {
            layout.releaseObject()
            layout = nil
        }
        
    }
    
    func displayUserContant(searchUser : SearchUser)
    {
        imgIsPrivate.isHidden = true
        isVarified.isHidden = true
        if searchUser.user != nil{
            lblTitle.text = "@\(searchUser.user.username!)"
            lblSubTitle.text = searchUser.user.fullName!
            lblfollowers.text =  searchUser.user.byline!
            imgIcon.displayImageFromURL(searchUser.user.profilePicUrl)
            
            AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                if self == nil {
                    return
                }
                if searchUser.user.fullName != "" && searchUser.user.username != "" && searchUser.user.byline != ""{
                    self!.lableContainer.removeConstraints(self!.constanttitle)
                    self!.lableContainer.removeConstraints(self!.constanttitleSubtittle)
                    self!.lableContainer.removeConstraints(self!.constanttitleFOLLOWERS)
                    self!.lableContainer.addConstraints(self!.constantAll)
                }
                else if searchUser.user.fullName != "" && searchUser.user.username != "" {
                    self!.lableContainer.removeConstraints(self!.constanttitle)
                    self!.lableContainer.removeConstraints(self!.constanttitleFOLLOWERS)
                    self!.lableContainer.removeConstraints(self!.constantAll)
                    self!.lableContainer.addConstraints(self!.constanttitleSubtittle)
                }
                else if searchUser.user.username != "" && searchUser.user.byline != "" {
                    self!.lableContainer.removeConstraints(self!.constanttitle)
                    self!.lableContainer.removeConstraints(self!.constantAll)
                    self!.lableContainer.removeConstraints(self!.constanttitleSubtittle)
                    self!.lableContainer.addConstraints(self!.constanttitleFOLLOWERS)
                }
                else if searchUser.user.username != ""  {
                    self!.lableContainer.removeConstraints(self!.constanttitle)
                    self!.lableContainer.removeConstraints(self!.constanttitleSubtittle)
                    self!.lableContainer.removeConstraints(self!.constanttitleFOLLOWERS)
                    self!.lableContainer.addConstraints(self!.constanttitle)
                }
                if searchUser.user.isPrivate == true
                {
                    self!.imgIsPrivate.isHidden = false
                }
                else
                {
                    self!.imgIsPrivate.isHidden = true
                }
                
                if searchUser.user.isVerified == true
                {
                    self!.isVarified.isHidden = false
                }
                else
                {
                    self!.isVarified.isHidden = true
                }
                
                self!.layoutIfNeeded()
            }
        }
    }
    
    func displayAllObjects(allFavUsers : AnyObject)
    {
        imgIsPrivate.isHidden = true
        isVarified.isHidden = true
        if allFavUsers is myCollection
        {
            let myCollections = allFavUsers as! myCollection
            let dic = myCollections.toDictionary()
            let collection : myCollection = myCollection.init(fromDictionary: dic)
            
            if let data : String = collection.data
            {
                if let dicData : NSDictionary = data.dictionary()
                {
                    let type : Int = collection.modelType
                   
                    switch type
                    {
                        
                    case ImageEditorViewType.follow.rawValue:
                        
                        let followersEdge = FollowersEdge.init(fromDictionary: dicData as! [String : AnyObject])
                        
                        lblTitle.text = "@\(followersEdge.node.username!)"
                        lblSubTitle.text = followersEdge.node.fullName!
                        lblfollowers.text = ""
                        imgIcon.displayImageFromURLWithPlaceholder(followersEdge.node.profilePicUrl, placeholder: UIImage(named: "postplaceholder"))
                       
                        imgIsPrivate.isHidden = true
                        
                        if followersEdge.node.isVerified == true
                        {
                            isVarified.isHidden = false
                        }
                        else
                        {
                            isVarified.isHidden = true
                        }
                        
                        if followersEdge.node.fullName != "" && followersEdge.node.username != "" {
                            self.lableContainer.removeConstraints(self.constanttitle)
                            self.lableContainer.removeConstraints(self.constantAll)
                            self.lableContainer.removeConstraints(self.constanttitleFOLLOWERS)
                            self.lableContainer.addConstraints(self.constanttitleSubtittle)
                        }
                        else if followersEdge.node.username != ""  {
                            self.lableContainer.removeConstraints(self.constantAll)
                            self.lableContainer.removeConstraints(self.constanttitleSubtittle)
                            self.lableContainer.removeConstraints(self.constanttitleFOLLOWERS)
                            self.lableContainer.addConstraints(self.constanttitle)
                        }
                        
                        break
                    case ImageEditorViewType.searchUser.rawValue:
                        
                        let searchUser = SearchUser.init(fromDictionary: dicData as! [String : AnyObject])
                        
                        lblTitle.text = "@\(searchUser.user.username!)"
                        lblSubTitle.text = searchUser.user.fullName!
                        lblfollowers.text =  searchUser.user.byline!
                        imgIcon.displayImageFromURLWithPlaceholder(searchUser.user.profilePicUrl, placeholder: UIImage(named: "postplaceholder"))
                        
                        if searchUser.user.isPrivate == true
                        {
                            imgIsPrivate.isHidden = false
                        }
                        else
                        {
                            imgIsPrivate.isHidden = true
                        }
                        
                        if searchUser.user.isVerified == true
                        {
                            isVarified.isHidden = false
                        }
                        else
                        {
                            isVarified.isHidden = true
                        }
                        
                       
                        if searchUser.user.fullName != "" && searchUser.user.username != "" && searchUser.user.byline != ""{
                            self.lableContainer.removeConstraints(self.constanttitle)
                            self.lableContainer.removeConstraints(self.constanttitleSubtittle)
                            self.lableContainer.removeConstraints(self.constanttitleFOLLOWERS)
                            self.lableContainer.addConstraints(self.constantAll)
                        }
                        else if searchUser.user.fullName != "" && searchUser.user.username != "" {
                            self.lableContainer.removeConstraints(self.constanttitle)
                            self.lableContainer.removeConstraints(self.constantAll)
                            self.lableContainer.removeConstraints(self.constanttitleFOLLOWERS)
                            self.lableContainer.addConstraints(self.constanttitleSubtittle)
                        }
                        else if searchUser.user.username != "" && searchUser.user.byline != "" {
                            self.lableContainer.removeConstraints(self.constanttitle)
                            self.lableContainer.removeConstraints(self.constantAll)
                            self.lableContainer.removeConstraints(self.constanttitleSubtittle)
                            self.lableContainer.addConstraints(self.constanttitleFOLLOWERS)
                        }
                        else if searchUser.user.username != ""  {
                            self.lableContainer.removeConstraints(self.constantAll)
                            self.lableContainer.removeConstraints(self.constanttitleSubtittle)
                            self.lableContainer.removeConstraints(self.constanttitleFOLLOWERS)
                            self.lableContainer.addConstraints(self.constanttitle)
                        }
                        
                        break
                        
                    default:
                        break
                    }
                    
                    lableContainer.layoutSubviews()
                    lableContainer.layoutIfNeeded()
                    self.layoutSubviews()
                    self.layoutIfNeeded()
                    self.contentView.layoutSubviews()
                    self.contentView.layoutIfNeeded()
                }
            }
        }
        else
        {
            
        }
        
    }
    
    func displayFollowersNode(followersNode : FollowersEdge)
    {
        imgIsPrivate.isHidden = true
        isVarified.isHidden = true
        if followersNode.node != nil
        {
            lblTitle.text = "@\(followersNode.node.username!)"
            lblSubTitle.text = followersNode.node.fullName
            lblfollowers.text = ""
            imgIcon.image = nil
            imgIcon.displayImageFromURL(followersNode.node.profilePicUrl)
            imgIsPrivate.isHidden = true
            
            if followersNode.node.isVerified == true
            {
                self.isVarified.isHidden = false
            }
            else
            {
                self.isVarified.isHidden = true
            }
            
           
            if followersNode.node.fullName != "" && followersNode.node.username != "" {
                self.lableContainer.removeConstraints(self.constanttitle)
                self.lableContainer.removeConstraints(self.constantAll)
                self.lableContainer.removeConstraints(self.constanttitleFOLLOWERS)
                self.lableContainer.addConstraints(self.constanttitleSubtittle)
            }
            else if followersNode.node.username != ""  {
                self.lableContainer.removeConstraints(self.constantAll)
                self.lableContainer.removeConstraints(self.constanttitleSubtittle)
                self.lableContainer.removeConstraints(self.constanttitleFOLLOWERS)
                self.lableContainer.addConstraints(self.constanttitle)
            }
            lableContainer.layoutSubviews()
            lableContainer.layoutIfNeeded()
            self.layoutSubviews()
            self.layoutIfNeeded()
            self.contentView.layoutSubviews()
            self.contentView.layoutIfNeeded()
            
        }
    }
    
    func imageOpenTapped(event: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = event
    }
    
    func setCellContant(icon : UIImage, title : String, subTitle : String) -> Void {
        lblTitle.text = title
        lblSubTitle.text = subTitle
        imgIcon.image = icon
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(self.btnTouchUpInside != nil)
        {
            self.btnTouchUpInside("image" as AnyObject,nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
