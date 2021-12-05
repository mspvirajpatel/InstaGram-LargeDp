//
//  SearchGenaralView.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 07/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus
import GoogleMobileAds

class SearchView: BaseView {
    
    // Mark: - Attributes -
    
    private var viewContant : UIView!
    
    var peopleListView : SearchTableView!
  
    var searchText : String = ""
    
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadViewControls()
        self.setViewlayout()
       
    }
    
    init(searchText: String) {
        super.init(frame: CGRect.zero)
        
        self.loadViewControls()
        self.setViewlayout()
        self.peopleListView.searchText = searchText
        self.peopleListView.searchPeople(query: searchText)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        print("SearchView Deinit called")
        self.releaseObject()
    }
    
    // MARK: - Layout -
    
    override func releaseObject() {
        super.releaseObject()
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if peopleListView != nil && peopleListView.superview != nil {
            peopleListView.removeFromSuperview()
            peopleListView = nil
        }
       
        if viewContant != nil && viewContant.superview != nil {
            viewContant.removeFromSuperview()
            viewContant = nil
        }
       
    }
    
    override func loadViewControls() {
        super.loadViewControls()
        self.backgroundColor = Color.appSecondaryBG.value
        
        viewContant = UIView(frame: .zero)
        viewContant.translatesAutoresizingMaskIntoConstraints = false
        viewContant.backgroundColor = .clear
        self.addSubview(viewContant)
    
        peopleListView = SearchTableView(frame: CGRect.zero)
        peopleListView.backgroundColor = Color.appSecondaryBG.value
        peopleListView.translatesAutoresizingMaskIntoConstraints = false
        viewContant.addSubview(peopleListView)
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = ["viewContant" : viewContant,
                                          "peopleListView" : peopleListView]
        
        let horizontalPadding : CGFloat = ControlLayout.horizontalPadding
        let verticalPadding : CGFloat = ControlLayout.verticalPadding
        let secondaryHorizontalPadding : CGFloat = ControlLayout.secondaryHorizontalPadding
        let secondaryVerticalPadding : CGFloat = ControlLayout.secondaryVerticalPadding
        
        let AddViewHeight : CGFloat = SystemConstants.IS_IPAD ? 50 : 50
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenheight = screenSize.height
        
        self.baseLayout.metrics = ["horizontalPadding" : horizontalPadding,
                                   "verticalPadding" : verticalPadding,
                                   "secondaryHorizontalPadding" : secondaryHorizontalPadding,
                                   "secondaryVerticalPadding" : secondaryVerticalPadding,
                                   "AddViewHeight" : AddViewHeight,
                                   "screenWidth" : screenWidth,
                                   "screenheight" : screenheight]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContant]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_H)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewContant]|", options: [.alignAllLeading, .alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.expandView(peopleListView, insideView: viewContant)
       
        self.layoutIfNeeded()
        self.layoutSubviews()
        baseLayout.releaseObject()
    }
    
    // MARK: - Public Interface -
    
        
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
}
