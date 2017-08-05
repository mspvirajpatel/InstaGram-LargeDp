//
//  BaseBarButtonItem.swift
//  ViewControllerDemo
//
//  Created by SamSol on 01/07/16.
//  Copyright © 2016 SamSol. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

enum BaseBarButtonItemType : Int {
    
    case unknown = -1
    case left = 1
    case right
    case select
    case copy
    case paste
    case done
}

class BaseBarButtonItem: UIBarButtonItem {
    
    // MARK: - Attributes -
    var buttonType : BaseBarButtonItemType = .unknown
    var baseButton : BaseButton!
    
    // MARK: - Lifecycle -
    
    init(itemType : BaseBarButtonItemType) {
        super.init()
        
        buttonType = itemType
        self.setCommonProperties()
        self.setlayout()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
        buttonType = .unknown
    }
    
    override var isEnabled: Bool {
        didSet {
            
            if(baseButton != nil)
            {
                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                    if self == nil{
                        return
                    }
                    
                    self!.baseButton.titleLabel?.text = ""
                    
                    if(self!.isEnabled){
                        self!.baseButton.titleLabel?.textColor = Color.activeBarButtonText.value
                        
                    }else{
                        self!.baseButton.titleLabel?.textColor = Color.disableBarButtonText.value
                    }
                }
            }
        }
    }
    
    
    deinit{
        baseButton = nil
    }
    
    
    // MARK: - Layout -
    
    func setCommonProperties(){
        
        baseButton = BaseButton(type: .custom)
        baseButton.titleLabel?.text = ""
        
        baseButton.backgroundColor = UIColor.clear
        baseButton.titleLabel?.textColor = Color.activeBarButtonText.value
        baseButton.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
        
        var iconFontSize : CGFloat!
        iconFontSize = 23.0
        
        var icon : FAType!
        icon = FAType.FARandom
        
        switch buttonType {
        case .left:
            
            icon = FAType.FAChevronCircleUp
            baseButton.setFAIcon(icon: icon, iconSize: iconFontSize, forState: .normal)
            break
            
        case .right:
            
            icon = FAType.FAChevronCircleDown
            baseButton.setFAIcon(icon: icon, iconSize: iconFontSize, forState: .normal)
            break
            
        case .select:
            
            baseButton .setFAIcon(icon: FAType.FAICursor, iconSize: iconFontSize, forState: UIControlState.normal)
            break
            
        case .copy:
            
            baseButton.setFAIcon(icon: FAType.FACopy, iconSize: iconFontSize - 3, forState: UIControlState.normal)
            break
            
        case .paste:
            
            icon = FAType.FAPaste
            baseButton.setFAIcon(icon: FAType.FAPaste, iconSize: iconFontSize - 3, forState: UIControlState.normal)
            
            break
            
        case .done:
            
            baseButton.titleLabel?.font = UIFont(name: FontStyle.bold, size: 14.0)!
            baseButton.backgroundColor = Color.activeBarButtonText.value
            baseButton.setTitleColor(Color.buttonPrimaryTitle.value, for: UIControlState())
            baseButton.setTitle("done".localize(), for: UIControlState())
            baseButton.setBorder(Color.barButtonBorder.value, width: ControlLayout.txtBorderWidth, radius: 8.0)
            
            break
            
        default:
            break
        }
        
        baseButton.sizeToFit()
        self.customView = baseButton
        iconFontSize = nil
        icon = nil
    }
    
    func setlayout(){
        
    }
    
    
    // MARK: - Public Interface -
    
    func setTarget(_ target : AnyObject?, action: Selector){
        baseButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
}
