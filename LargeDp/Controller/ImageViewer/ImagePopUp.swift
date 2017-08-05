//
//  ImagePopUp.swift
//  InstaLargerDp
//
//  Created by MacMini-2 on 19/04/17.
//  Copyright © 2017 WebMobTech-3. All rights reserved.
//

import UIKit
import SwiftEventBus

class ImagePopUp: BaseView {

    // Mark: - Attributes -
    
    var imgProfile : BaseImageView!
    var placeholder : UIImage?
    var imageView: UIView!
    
    var btnTouchUpInside : ControlTouchUpInsideEvent!
    var anyData :AnyObject!

    var editorType : ImageEditorViewType!
    
    var peopleData : Item!
    var tagData : ProfileNode!
    var userprofile : UserProfileModel!
    var followersEdge : FollowersEdge!
    var image : UIImage!
    var searchUser : SearchUser!
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    init(frame : CGRect,placeholder : UIImage? ,iImageEditorType : ImageEditorViewType, mediaData : AnyObject)
    {
        super.init(frame: (AppUtility.getAppDelegate().window?.frame)!)
        self.placeholder = placeholder
        self.anyData = mediaData
        
        editorType = iImageEditorType
        
        switch iImageEditorType {
            
        case .profile:
            if mediaData is UserProfileModel
            {
                self.userprofile = mediaData as! UserProfileModel
            }
            break
            
            
        case .follow:
            if mediaData is FollowersEdge
            {
                self.followersEdge = mediaData as! FollowersEdge
            }
            break
        case .searchUser:
            if mediaData is SearchUser
            {
                self.searchUser = mediaData as! SearchUser
            }
            break
        default:
            break
        }
        
        self.loadViewControls()
        self.setViewlayout()
        self.setImageViewer()
    }
    
    init(placeholder : UIImage? , model : FollowersEdge)
    {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.followersEdge = model
        self.loadViewControls()
        self.setViewlayout()
        self.setImageViewer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if imgProfile.superview != nil && imgProfile != nil {
            imgProfile.removeFromSuperview()
            imgProfile = nil
        }
        
        placeholder = nil
    }
    
    // MARK: - Layout -
    override func loadViewControls() {
        super.loadViewControls()
       
        imageView = UIView(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        imgProfile = BaseImageView(type: BaseImageViewType.defaultImg, superView: imageView)
        imgProfile.contentMode = .scaleAspectFit
        
        //Tap gesture on image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bgTapped(tapGestureRecognizer:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        self.baseLayout.viewDictionary = ["imageView":imageView ,
                                          "imgProfile" : imgProfile]
        
        let horizontalPadding : CGFloat = ControlLayout.horizontalPadding
        let virticalPadding : CGFloat = ControlLayout.verticalPadding
        let secondaryHorizontalPadding : CGFloat = ControlLayout.secondaryHorizontalPadding
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        
        self.baseLayout.metrics = ["horizontalPadding" : horizontalPadding,
                                   "virticalPadding" : virticalPadding,
                                   "secondaryHorizontalPadding" : secondaryHorizontalPadding,
                                   "secondaryVerticalPadding" : secondaryVerticalPadding]
        
//        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[imageView(180)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
//        self.addConstraints(baseLayout.control_H)
//        
//        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView(180)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
//        self.addConstraints(baseLayout.control_V)
////
        
        baseLayout.size_Width = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: SystemConstants.IS_IPAD ? 0.4 : 0.45, constant: 1.0)
        self.addConstraint(baseLayout.size_Width)
        
        baseLayout.size_Height = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1.0 , constant: 1.0)
        self.addConstraint(baseLayout.size_Height)
        
        baseLayout.position_CenterX = NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        self.addConstraint(baseLayout.position_CenterX)
        
        baseLayout.position_CenterY = NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.addConstraint(baseLayout.position_CenterY)
        
      
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[imgProfile]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        imageView.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgProfile]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        imageView.addConstraints(baseLayout.control_V)
        
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    func setImageViewer()
    {
        switch editorType.rawValue {
        
        case ImageEditorViewType.profile.rawValue:
            
            if userprofile != nil && userprofile.user != nil
            {
                let aString = userprofile.user.profilePicUrlHd!
                let newString = aString.replacingOccurrences(of: "/s150x150", with: "", options: .literal, range: nil)
                userprofile.user.profilePicUrlHd = newString
                
                self.imgProfile.displayImageFromURLWithPlaceholder(newString, placeholder: self.placeholder)
            }
            break
       
        case ImageEditorViewType.follow.rawValue:
            
            if self.followersEdge != nil && self.followersEdge.node != nil
            {
                self.imgProfile.displayImageFromURL(self.followersEdge.node.profilePicUrl)
                self.imgProfile.displayImageFromURLWithPlaceholder(self.followersEdge.node.profilePicUrl320, placeholder: self.placeholder)
            }
            break
        case ImageEditorViewType.searchUser.rawValue:
            
            if self.searchUser != nil && self.searchUser.user != nil
            {
                self.imgProfile.displayImageFromURL(self.searchUser.user.profilePicUrl)
                self.imgProfile.displayImageFromURLWithPlaceholder(self.searchUser.user.profilePicUrl320, placeholder: self.placeholder)
            }
            break
        default:
            break
        }
    }
    
    func showInView(_ aView: UIView!, animated: Bool)
    {
      //  aView.addSubview(self)
        AppUtility.getAppDelegate().window?.addSubview(self)

        
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.removeFromSuperview()
            }
        });
    }
    
    func btnTapped(event: @escaping ControlTouchUpInsideEvent) {
        btnTouchUpInside = event
    }
    
    func bgTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.removeAnimate()
    }

    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
        if(self.btnTouchUpInside != nil)
        {
            self.btnTouchUpInside("ImageTap" as AnyObject,nil)
        }
        
    }
    
    // MARK: - Internal Helpers -
   
    
    // MARK: - Server Request -

}
