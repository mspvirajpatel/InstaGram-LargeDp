//
//  FeedbackView.swift
//  FlikoMapia
//
//  Created by Viraj Patel on 23/02/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftEventBus
import GoogleMobileAds

class FeedbackView: BaseView {
    
    // MARK: - Attributes -
    var viewAdd : BaseAddBannerView!
    var txtname : BaseTextField!
    var txtemail: BaseTextField!
    var txtdesc : BaseTextView!
    var btnsubmit : BaseButton!
    var dictdevice : [String:Any]!
    
    // MARK: - LifeCycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("Feedback view deinit")
        
        self.releaseObject()
    }
    
    override func releaseObject() {
        super.releaseObject()
        
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        if viewAdd != nil && viewAdd.superview != nil {
            viewAdd.removeFromSuperview()
            //viewAdd = nil
        }
        if txtname != nil && txtname.superview != nil{
            txtname.removeFromSuperview()
            txtname = nil
        }
        
        if txtemail != nil && txtemail.superview != nil{
            txtemail.removeFromSuperview()
            txtemail = nil
        }
        
        if txtdesc != nil && txtdesc.superview != nil{
            txtdesc.removeFromSuperview()
            txtdesc = nil
        }
        
        if btnsubmit != nil && btnsubmit.superview != nil{
            btnsubmit.removeFromSuperview()
            btnsubmit = nil
        }
    }
    
    // MARK: - Layout -
    
    override func loadViewControls() {
        super.loadViewControls()
        
        let floatVersion = (UIDevice.current.systemVersion as NSString).floatValue
       
        dictdevice = ["OS":floatVersion,"Device":Luminous.System.Hardware.Device.current.modelName,"Version":BSApp.build,"type":"iOS"]
        
        txtname = BaseTextField(iSuperView: self, TextFieldType: .noAutoScroll)
        txtname.placeholder = "fbname".localize()
        txtemail = BaseTextField(iSuperView: self, TextFieldType: .noAutoScroll)
        txtemail.placeholder = "fbemail".localize()
        txtemail.keyboardType = .emailAddress
        txtdesc = BaseTextView(iSuperView: self)
        txtdesc.placeholder = "fbDesc".localize()
        txtdesc.textColor = Color.textFieldText.value
        btnsubmit = BaseButton.init(ibuttonType: BaseButtonType.primary, iSuperView: self)
        btnsubmit.setTitle(NSLocalizedString("fbsubmit", comment: ""), for: .normal)
        btnsubmit.addTarget(self, action: #selector(onSubmitClick), for: .touchUpInside)
       
        viewAdd = BaseAddBannerView(adSize: kGADAdSizeBanner, bannerKey: InAddvertise.KAddBannerKey)
        self.addSubview(viewAdd)
        self.bringSubview(toFront: viewAdd)

    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout = AppBaseLayout()
        
        let txtnametoppading : CGFloat = 30
        let txtleftrightpading : CGFloat = 10
        let txtdescheight : CGFloat = 120
       
        
        baseLayout.position_Top = NSLayoutConstraint(item: txtname, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute:  NSLayoutAttribute.top, multiplier: 1, constant: txtnametoppading)
        
        baseLayout.position_Left = NSLayoutConstraint(item: txtname, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: txtleftrightpading)
        
        baseLayout.position_Right = NSLayoutConstraint(item: txtname, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -txtleftrightpading)
        
        self.addConstraints([ baseLayout.position_Top,baseLayout.position_Left,baseLayout.position_Right])
        
        
        baseLayout.position_Top = NSLayoutConstraint(item: txtemail, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: txtname, attribute:  NSLayoutAttribute.bottom, multiplier: 1, constant: txtleftrightpading)
        
        baseLayout.position_Left = NSLayoutConstraint(item: txtemail, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: txtleftrightpading)
        
        baseLayout.position_Right = NSLayoutConstraint(item: txtemail, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -txtleftrightpading)
        
        self.addConstraints([ baseLayout.position_Top,baseLayout.position_Left,baseLayout.position_Right])
        
        
        baseLayout.position_Top = NSLayoutConstraint(item: txtdesc, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: txtemail, attribute:  NSLayoutAttribute.bottom, multiplier: 1, constant: txtleftrightpading)
        
        baseLayout.position_Left = NSLayoutConstraint(item: txtdesc, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: txtleftrightpading)
        
        baseLayout.position_Right = NSLayoutConstraint(item: txtdesc, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -txtleftrightpading)
        baseLayout.size_Height = NSLayoutConstraint(item: txtdesc, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem:nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: txtdescheight)
        
        self.addConstraints([ baseLayout.position_Top,baseLayout.position_Left,baseLayout.position_Right,baseLayout.size_Height])
        
        
        baseLayout.position_Top = NSLayoutConstraint(item:btnsubmit, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: txtdesc, attribute:  NSLayoutAttribute.bottom, multiplier: 1, constant: txtleftrightpading)
        
        baseLayout.position_Right = NSLayoutConstraint(item: btnsubmit, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant:0)
        
        baseLayout.size_Width = NSLayoutConstraint(item: btnsubmit, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 0.4, constant: 1.0)
        
        self.addConstraints([ baseLayout.position_Top, baseLayout.size_Width,baseLayout.position_Right])
        
        
        self.baseLayout.viewDictionary = ["viewAdd" : viewAdd]
        
        self.baseLayout.metrics = [:]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewAdd]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[viewAdd]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
    }
    
    // MARK: - User Interaction -
    
    func onSubmitClick()
    {
        if (self.txtemail.text == "") && (self.txtname.text == "") && (self.txtdesc.text?.trimmed() == "")
        {
            self.displayBottomToast(message: "enterText".localize())
        }
        else if (self.txtname.text?.length2)! <= 0
        {
            self.displayBottomToast(message: "entername".localize())
            
        }
        else if (self.txtemail.text?.length2)! <= 0
        {
            self.displayBottomToast(message: "enteremail".localize())
            
        }
        else if !self.isValidEmail(testStr: txtemail.text!)
        {
            self.displayBottomToast(message: "validEmail".localize())
        }
        else if self.txtdesc.text?.trimmed() == ""
        {
             self.displayBottomToast(message: "enterdesc".localize())
        }
        else
        {
            self.endEditing(true)
            
            var jsonString : NSString = ""
            do
            {
                let jsonData : Data = try JSONSerialization .data(withJSONObject: self.dictdevice!, options: JSONSerialization.WritingOptions(rawValue : 0))
                jsonString = NSString(data: jsonData ,encoding: String.Encoding.utf8.rawValue)!
            }
            catch{}
            
            let headers : HTTPHeaders = HTTPHeaders.init()
            
            let dicParameter : NSDictionary = ["appname":BSApp.name,
                                               "appmessage":"Now create your own collection of Instagram images and share/ repost with your friends on Instagram.",
                                               "appstorelink":APIConstant.itunesStorelink,
                                            "appplaystorelink":APIConstant.GoogleStorelink,"name":self.txtname.text!,"email":self.txtemail.text!,"message":self.txtdesc.text!,
                                            "feedbackreceiver": ""]
            
            var jsonString2 : NSString = ""
            do
            {
                let jsonData : Data = try JSONSerialization .data(withJSONObject: dicParameter, options: JSONSerialization.WritingOptions(rawValue : 0))
                jsonString2 = NSString(data: jsonData ,encoding: String.Encoding.utf8.rawValue)!
            }
            catch{}
            
            let dicParameter2 : NSDictionary = ["mailcontent":jsonString2,"deviceInfo":jsonString]
            
            BaseAPICall().localAPIspostRequest(URL: "Enter URL", Parameter: dicParameter2, Type: .FeedBack, Headers: headers, completionHandler: { [weak self] (result) in
                if self == nil{
                    return
                }
                
                switch result{
                case .Success(_, let error):
                    
                    self!.hideProgressHUD()
                    
                    if error?.alertMessage != nil
                    {
                        self?.displayBottomToast(message: "sendsccuess".localize())
                       
                    }
                    else
                    {
                        self?.displayBottomToast(message: (error?.alertMessage)!)
                    }
                    
                    
                    self!.txtemail.text = ""
                    self!.txtname.text = ""
                    self!.txtdesc.text = ""
                    
                    let navitaion : UIViewController = self!.getViewControllerFromSubView()!
                    navitaion.navigationController!.popViewController(animated: true)
                    
                    break
                    
                case .Error(let error):
                    
                    self!.hideProgressHUD()
                    
                    if error?.alertMessage != nil
                    {
                         self?.displayBottomToast(message: "errorapi".localize())
                        
                    }
                    else
                    {
                        self?.displayBottomToast(message: (error?.alertMessage)!)
                    }
                    
                    self!.txtemail.text = ""
                    self!.txtname.text = ""
                    self!.txtdesc.text = ""
                    break
                case .Internet(let isOn):
                    
                    self!.handleNetworkCheck(isAvailable: isOn, viewController: self!, showLoaddingView: true)
                    
                    break
                }
            })
        }
    }
    
    // MARK : - Email Validation -
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

