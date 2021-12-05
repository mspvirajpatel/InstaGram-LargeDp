//
//  NativeAddCell.swift
//  InstaLargerDp
//
//  Created by Viraj Patel on 03/05/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit

class NativeAddCell: UITableViewCell {
    
    // MARK: - Attrubutes -
    var innerView : UIView!
    // MARK: - Lifecycle -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.loadViewControls()
        self.setViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }
    deinit {
        print("NativeAddTableViewCell deinit called")
        NotificationCenter.default.removeObserver(self)
        
        if innerView != nil && innerView.superview != nil {
            innerView.removeFromSuperview()
            innerView = nil
        }
      
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
//        innerView.layer.masksToBounds = false
//        //innerView.layer.cornerRadius = 2.0
//        innerView.layer.shadowColor = UIColor.black.cgColor
//        innerView.layer.shadowOffset = CGSize.init(width: 0.5, height: 1)
//        innerView.layer.shadowRadius = 1.0
//        innerView.layer.shadowOpacity = 0.75
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Layout - 
    
    func loadViewControls()
    {
        self.contentView.backgroundColor = Color.appSecondaryBG.value
        self.backgroundColor = Color.appSecondaryBG.value
    
        self.contentView.clipsToBounds = false
        
        self.clipsToBounds = false
        self.selectionStyle = .none
        
        innerView = UIView(frame: CGRect.zero)
        innerView.backgroundColor = UIColor.white
        innerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(innerView)
    }
    
    func setViewLayout()
    {
        var layout : AppBaseLayout! = AppBaseLayout()
        
        layout.viewDictionary = ["innerView" : innerView]
        
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
        layout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[innerView]-5-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_H)
        
        layout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[innerView]-5-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: layout.metrics, views: layout.viewDictionary)
        self.contentView.addConstraints(layout.control_V)
        
        innerView.layoutSubviews()
        innerView.layoutIfNeeded()
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        do {
            layout.releaseObject()
            layout = nil
        }
        
    }

}
