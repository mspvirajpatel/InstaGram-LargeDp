//
//  BaseNavigationController.swift
//  ViewControllerDemo
//
//  Created by VirajPatel on 01/07/16.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController,UIGestureRecognizerDelegate {

    // MARK: - Interface
    @IBInspectable open var clearBackTitle: Bool = true
    
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultParameters()
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
   
    
    
    // MARK: - Public Interface -
    func setDefaultParameters(){
        
       // self.edgesForExtendedLayout = UIRectEdge.none
        
        var navigationBarFont: UIFont? = UIFont(name: FontStyle.regular, size: SystemConstants.IS_IPAD ? 22.0 : 18.0)
       // UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Color.navigationTitle.value,NSFontAttributeName: navigationBarFont!] as [String : Any]
        
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Color.navigationTitle.value, NSAttributedString.Key.font: navigationBarFont!] as [NSAttributedString.Key : Any]
        
        self.navigationBar.tintColor =  UIColor.white //Color.navigationTitle.value
        
        self.navigationBar.barTintColor = Color.navigationBG.value
        self.navigationBar.isTranslucent = false
        
        self.view.backgroundColor = UIColor.clear
        //self.navigationBar.setBottomBorder(UIColor(rgbValue: ColorStyle.btnPrimaryBG, alpha: 1.0), width: 1.0)
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        defer{
            navigationBarFont = nil
        }
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            self.view.endEditing(true)
            let point = gestureRecognizer.translation(in: self.view)
            if point.x >= 89.0 {
//                if (AppUtility.getAppDelegate().sideMenuController.navigationController?.viewControllers.count)! >= 1
//                {
//                    self.frostedViewController.view.endEditing(true)
//                    self.frostedViewController.panGestureRecognized(gestureRecognizer)
//                }
            }
            
        }
    }
    
    func setPopOverParameters(){
        
    }
    
    // MARK: - User Interaction -
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        controlClearBackTitle()
        super.pushViewController(viewController, animated: animated)
    }
    
    override open func show(_ vc: UIViewController, sender: Any?) {
        controlClearBackTitle()
        super.show(vc, sender: sender)
    }
    
    // MARK: - Internal Helpers -
}

extension BaseNavigationController {
    
    func controlClearBackTitle() {
        if self.clearBackTitle {
            topViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
}
