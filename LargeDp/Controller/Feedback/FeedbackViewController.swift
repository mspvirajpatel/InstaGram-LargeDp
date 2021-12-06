//
//  FeedbackViewController.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 25/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import SwiftEventBus

class FeedbackViewController: BaseViewController {
    
    // MARK: - Attributes -
    
    var feedbackView : FeedbackView!
    
    // MARK: - Life Cycle -
    
    override init()
    {
        let  subView : FeedbackView = FeedbackView(frame:CGRect.zero)
        super.init(iView: subView, andNavigationTitle: "feedback".localize())
        
        feedbackView = subView
        
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        AppUtility.executeTaskInMainThreadAfterDelay(0.5, completion: {
//            self.feedbackView.viewAdd.requestBannerAd(rootController: self)
        })
        
    }
    
    
    deinit{
        
        print("Feedback Controller Deinit Called")
        
        NotificationCenter.default.removeObserver(self)
        SwiftEventBus.unregister(self)
        
        if feedbackView != nil && feedbackView.superview != nil{
            feedbackView.releaseObject()
            feedbackView.removeFromSuperview()
            feedbackView = nil
        }
    }
    
    
    // MARK: - Layout -
    
    override func loadViewControls()
    {
        super.loadViewControls()
        
    }
    override func setViewlayout() {
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    
}
