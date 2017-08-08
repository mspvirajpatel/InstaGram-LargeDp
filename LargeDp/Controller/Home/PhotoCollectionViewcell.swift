
//
//  PhotoCollectionViewcell.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 06/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus


class PhotoCollectionViewcell : UICollectionViewCell {
    
    // MARK: - Attributes -
    var imgPhoto : BaseImageView!
    var imgSelected : BaseImageView!
    var parentcollection:UICollectionView!
    var isImageSelected : Bool = false
    weak var overlayView: UIView?
    weak var overlayImageView: UIImageView?
    var userName : BaseLabel!
    var userDetails : BaseLabel!
    var userLastseen : BaseLabel!
    var innerView : UIView!
    var isVarified : BaseImageView!
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    
    var selectionTintColor: UIColor = UIColor.black.withAlphaComponent(0.8) {
        didSet {
            overlayView?.backgroundColor = selectionTintColor
        }
    }
    
    open var selectionImageTintColor: UIColor = .white {
        didSet {
            overlayImageView?.tintColor = selectionImageTintColor
        }
    }
    
    open var selectionImage: UIImage? {
        didSet {
            overlayImageView?.image = selectionImage?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    
    // MARK: - Life Cycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadViewControls()
        self.setViewControlsLayout()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    
    deinit {
        print("PhotoCollectionView Cell deinit called")
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        //self.safeRemoveObserver()
        
        if imgSelected != nil && imgSelected.superview != nil {
            imgSelected.removeFromSuperview()
             imgSelected = nil
        }
      
        if imgPhoto != nil && imgPhoto.superview != nil {
            imgPhoto.removeFromSuperview()
            imgPhoto = nil
        }
        
        if parentcollection != nil && parentcollection.superview != nil {
            parentcollection.removeFromSuperview()
            parentcollection = nil
        }
        if userDetails != nil && userDetails.superview != nil {
            userDetails.removeFromSuperview()
            userDetails = nil
        }
        if userName != nil && userName.superview != nil {
            userName.removeFromSuperview()
            userName = nil
        }
        if isVarified != nil && isVarified.superview != nil {
            isVarified.removeFromSuperview()
            isVarified = nil
        }

        
        
    }
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        //self.parallaxRatio = first;
        if imgPhoto != nil{
            imgPhoto.clipsToBounds = true
            imgPhoto.layer.cornerRadius = imgPhoto.frame.size.width / 2
        }
        innerView.layer.masksToBounds = false
        
//        innerView.layer.cornerRadius = 2.0
//        innerView.layer.shadowColor = UIColor.black.cgColor
//        innerView.layer.shadowOffset = CGSize.init(width: 0.0, height: 1)
//        innerView.layer.shadowRadius = 5.0
//        innerView.layer.shadowOpacity = 0.60

        self.updateProperties()
        
        self.updateShadowPath()
    }
    
    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    fileprivate func updateProperties() {
        
        innerView.layer.cornerRadius = 3.0
        innerView.layer.shadowColor = UIColor.black.cgColor
        innerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        innerView.layer.shadowRadius = 3.0
        innerView.layer.shadowOpacity = 0.5
    }
    
    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    fileprivate func updateShadowPath() {
       // innerView.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    
    func loadViewControls()
    {
        self.contentView.backgroundColor = UIColor.white
        self.contentView.clipsToBounds = false
        self.backgroundColor = UIColor.white
        self.clipsToBounds = false
        
        innerView = UIView(frame: CGRect.zero)
        innerView.backgroundColor = UIColor.white
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(innerView)

        imgPhoto = BaseImageView(type: .defaultImg, superView: innerView)
        imgPhoto.contentMode = .scaleAspectFit
        imgPhoto.tintColor = Color.sideMenuText.value
        
        imgSelected = BaseImageView(type: .defaultImg, superView: innerView)
        self.imgSelected.alpha = 1
        imgSelected.image = UIImage(named: "PrivacyIcon")
        imgSelected.isHidden = true
        
        isVarified = BaseImageView(type: .defaultImg, superView: innerView)
        isVarified.image = UIImage(named: "VerifyUser")
        isVarified.isHidden = true
        
        userName = BaseLabel.init(labelType: .medium, superView: innerView)
        userName.backgroundColor = .clear
        userName.textAlignment = .center
        userName.font = UIFont(name: FontStyle.bold, size: SystemConstants.IS_IPAD ? 17.0 : 13.0)
        
        userDetails = BaseLabel.init(labelType: .small, superView: innerView)
        userDetails.textAlignment = .center
        userDetails.font = UIFont(name: FontStyle.regular, size: SystemConstants.IS_IPAD ? 15.0 : 11.0)
     
        userLastseen = BaseLabel.init(labelType: .small, superView: innerView)
        userLastseen.textAlignment = .center
        userLastseen.font = UIFont(name: FontStyle.regular, size: SystemConstants.IS_IPAD ? 15.0 : 11.0)
       
    }
    
    
    func setViewControlsLayout() {
        
        let layout : AppBaseLayout = AppBaseLayout()
        
        layout.viewDictionary = ["innerView" : innerView,
                                 "imgPhoto" : imgPhoto,
                                 "imgSelected" : imgSelected,
                                 "userName" :userName,
                                 "userDetails" : userDetails,
                                 "userLastseen" : userLastseen,
                                 "isVarified" : isVarified]
        
        let horizontalPadding : CGFloat = ControlLayout.horizontalPadding
        let verticalPadding : CGFloat = ControlLayout.verticalPadding
        let secondaryHorizontalPadding : CGFloat = ControlLayout.secondaryHorizontalPadding
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        
        layout.metrics = ["horizontalPadding" : horizontalPadding,
                               "verticalPadding" : verticalPadding,
                               "secondaryHorizontalPadding" : secondaryHorizontalPadding,
                               "secondaryVerticalPadding" : secondaryVerticalPadding]
       
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[innerView]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[innerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_V)

        
        //imagPhoto
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[userName]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_H)
    
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[userDetails]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_H)
        
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-2-[userLastseen]-2-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_H)
        
        innerView.layoutSubviews()
        innerView.layoutIfNeeded()
        
        imgPhoto.centerXAnchor.constraint(equalTo: self.userName.centerXAnchor).isActive = true
        imgPhoto.widthAnchor.constraint(equalToConstant: 120 * 0.70).isActive = true
        imgPhoto.heightAnchor.constraint(equalTo: imgPhoto.widthAnchor).isActive = true
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-25-[imgPhoto]-5-[userName]-2-[userDetails]-2-[userLastseen]-5-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_V)
        
        
        
        //Selected Image
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[imgSelected]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[imgSelected]", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_V)
        
        layout.size_Height = NSLayoutConstraint(item: imgSelected, attribute: .height, relatedBy: .equal, toItem: innerView, attribute: .height, multiplier: 0.10, constant: 0)
        innerView.addConstraint(layout.size_Height)
        
        layout.size_Width = NSLayoutConstraint(item: imgSelected, attribute: .width, relatedBy: .equal, toItem: imgSelected, attribute: .height, multiplier: 1.0, constant: 0)
        innerView.addConstraint(layout.size_Width)
        
        
        //isVarified Image
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[isVarified]", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[isVarified]", options: NSLayoutFormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        innerView.addConstraints(layout.control_V)
        
        layout.size_Height = NSLayoutConstraint(item: isVarified, attribute: .height, relatedBy: .equal, toItem: innerView, attribute: .height, multiplier: 0.10, constant: 0)
        innerView.addConstraint(layout.size_Height)
        
        layout.size_Width = NSLayoutConstraint(item: isVarified, attribute: .width, relatedBy: .equal, toItem: imgSelected, attribute: .height, multiplier: 1.0, constant: 0)
        innerView.addConstraint(layout.size_Width)
        
        innerView.layoutSubviews()
        innerView.layoutIfNeeded()
        self.layoutSubviews()
        self.layoutIfNeeded()
        
    }
  
    
    func configureddatawithModel(model:AnyObject)
    {
        isVarified.isHidden = true
         imgSelected.isHidden = true
            if model is myCollection
            {
                let myCollection = model as! myCollection
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
                            self.imgPhoto.displayImageFromURLWithPlaceholder(followersEdge.node.profilePicUrl, placeholder: UIImage(named: "postplaceholder"))
                            imgSelected.isHidden = true
                            
                            if followersEdge.node.isVerified == true
                            {
                                isVarified.isHidden = false
                            }
                            else
                            {
                                isVarified.isHidden = true
                            }
                            
                            var data : String = ""
                            if let modelType = dic["timeStamp"] as? String
                            {
                                data = modelType
                            }
                            
                            let timestamp = Double(data)
                            let date : NSDate = NSDate(timeIntervalSince1970: TimeInterval(timestamp!))
                            userLastseen.text = AppUtility.timeAgoSinceDate(date:date, numericDates:true)
                            
                            userName.text = followersEdge.node.fullName!
                            userDetails.text = "@\(followersEdge.node.username!)"
                            
                            break
                        case ImageEditorViewType.searchUser.rawValue:
                            
                            let searchUser = SearchUser.init(fromDictionary: dicData as! [String : AnyObject])
                            self.imgPhoto.displayImageFromURLWithPlaceholder(searchUser.user.profilePicUrl, placeholder: UIImage(named: "postplaceholder"))
                            if searchUser.user.isPrivate == true
                            {
                                imgSelected.isHidden = false
                                
                            }
                            else
                            {
                                imgSelected.isHidden = true
                            }
                            
                            var data : String = ""
                            if let modelType = dic["timeStamp"] as? String
                            {
                                data = modelType
                            }
                            
                            let timestamp = Double(data)
                            let date : NSDate = NSDate(timeIntervalSince1970: TimeInterval(timestamp!))
                            userLastseen.text = AppUtility.timeAgoSinceDate(date:date, numericDates:true)
                            
                            userName.text = searchUser.user.fullName!
                            userDetails.text = "@\(searchUser.user.username!)"
                            
                            break
                            
                        default:
                            break
                        }

                        
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
    
    
}
