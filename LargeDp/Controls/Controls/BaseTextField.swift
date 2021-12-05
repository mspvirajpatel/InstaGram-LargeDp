//
//  BaseTextField.swift
//  ViewControllerDemo
//
//  Created by VirajPatel on 01/07/16.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit

/**
 Respondent Direction Type Enum
 */
enum ResponderDirectionType : Int {
    
    case leftResponderDirectionType = 1
    case rightResponderDirectionType = 2
}

/**
 Base TextField Type
 
 - primary: Default Type
 - noAutoScroll: For Not want Auto Scroll when keyboard show
 - showPassword: For Password Textfiedl with show/hide button
 - withoutClear: For TextField Without clear button
 
 */
enum BaseTextFieldType : Int {
    
    case primary = 0 // Default Type
    case noAutoScroll // For Not want Auto Scroll when keyboard show
    case showPassword // For Password Textfiedl with show/hide button
    case withoutClear // For TextField Without clear button
}

/**
 Class for Base TextField. Its public variable as per under.
 
 - leftArrowButton: object of left arrow button on keyboard assesory view
 - rightArrowButton: object of right arrow button on keyboard assesory view
 - copyButton: object of Copy Button for implemented copy functionality
 - inputAccessory: variable for show input accessory view on keyword while editing like done,next and preview button
 - baseLayout: Object for layout class
 - charaterLimit: for define maximum character limit on textfield
 -baseTextFieldType: TextField Type.
 
 */
class BaseTextField: UITextField, UITextFieldDelegate {
    
    // MARK: - Attributes -
    var leftArrowButton : BaseBarButtonItem!
    var rightArrowButton : BaseBarButtonItem!
    
    var copyButton : BaseBarButtonItem!
    var pasteButton : BaseBarButtonItem!
    
    var inputAccessory : UIView!
    
    var charaterLimit : Int = 9999
    var type : BaseTextFieldType = BaseTextFieldType.primary
    
    // MARK: - Lifecycle -
    
    init(iSuperView: UIView?) {
        super.init(frame: CGRect.zero)
        
        self.setCommonProperties()
        self.setlayout()
        
        if(iSuperView != nil){
            iSuperView!.addSubview(self)
            self.delegate = self
        }
    }
    
    init(iSuperView : UIView? , TextFieldType baseType : BaseTextFieldType)
    {
        super.init(frame : CGRect.zero)
        
        type = baseType
        
        self.setCommonProperties()
        self.setlayout()
        
        if iSuperView != nil
        {
            iSuperView?.addSubview(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    
    /**
     override the Draw placeholder method of UITextField class for set the placeholder as per our requirement like put padding at left side of placeholder.
     */
    override func drawPlaceholder(in rect: CGRect)
    {
        if(self.placeholder!.responds(to: #selector(NSString.draw(at:withAttributes:))))
        {
            
            var attributes : [NSAttributedString.Key: AnyObject]! = [NSAttributedString.Key.foregroundColor : Color.textFieldPlaceholder.withAlpha(0.45),
                                                                     NSAttributedString.Key.font : self.font!]
            
            var boundingRect : CGRect! = self.placeholder!.boundingRect(with: rect.size, options: NSStringDrawingOptions(rawValue: 0), attributes: attributes, context: nil)
            
            switch type
            {
            case .withoutClear:
                self.placeholder!.draw(at: CGPoint(x: (rect.size.width / 2) - boundingRect.size.width / 2, y: (rect.size.height / 2) - boundingRect.size.height / 2), withAttributes: attributes)
                break
            default:
                self.placeholder!.draw(at: CGPoint(x: 0, y: (rect.size.height/2) - boundingRect.size.height/2), withAttributes: attributes)
                break
            }
            attributes.removeAll()
            attributes = nil
            boundingRect = nil
        }
    }
    
    /**
     Override the TextRect Method of UITextField class for set the Text in controlr and put left and right padding.
     
     */
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        var customBounds : CGRect!
        
        switch type {
        case .showPassword:
            
            customBounds = CGRect(x: bounds.origin.x + ControlLayout.textLeftPadding,y: bounds.origin.y,width: bounds.size.width - 4.8 * ControlLayout.textLeftPadding , height: bounds.size.height)
            break
            
        case .withoutClear:
            
            customBounds = CGRect(x: bounds.origin.x , y: bounds.origin.y,width : bounds.size.width ,height: bounds.size.height)
            break
            
        default:
            
            customBounds = CGRect(x:bounds.origin.x + ControlLayout.textLeftPadding,y:  bounds.origin.y,width : bounds.size.width - 3.8*ControlLayout.textLeftPadding,height: bounds.size.height)
            break
        }
        
        return customBounds
    }
    
    /**
     Override the editingRect Method of UITextField class while editing is on in textfield for set the Text in controlr and put left and right padding.
     
     */
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        var customBounds : CGRect!
        
        switch type {
        case .showPassword :
            
            customBounds = CGRect(x: bounds.origin.x + ControlLayout.textLeftPadding, y: bounds.origin.y,width:  bounds.size.width - 4.8 * ControlLayout.textLeftPadding, height:  bounds.size.height)
            break
            
        case .withoutClear:
            
            customBounds = CGRect(x: bounds.origin.x ,y: bounds.origin.y,width:  bounds.size.width , height:  bounds.size.height)
            break
            
        default:
            
            customBounds = CGRect(x: bounds.origin.x + ControlLayout.textLeftPadding,y: bounds.origin.y,width:  bounds.size.width - 3.8 * ControlLayout.textLeftPadding, height:  bounds.size.height)
            break
        }
        return customBounds!
    }
    
    override var text: String?{
        didSet{
            self.displayClearButton()
        }
    }
    
    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit{
        
        inputAccessory = nil
        leftArrowButton = nil
        rightArrowButton = nil
        
        copyButton = nil
        pasteButton = nil
    }
    
    // MARK: - Layout -
    /**
     This method set the commond propary of textfield as per Type
     */
    func setCommonProperties(){
        
        switch type
        {
        case .noAutoScroll:
            
            self.setShowToolbar(false)
            self.clearButtonMode = .whileEditing
            self.textAlignment = .left
            break
            
        case .primary:
            
            self.clearButtonMode = .whileEditing
            self.returnKeyType = .default
            self.setShowToolbar(true)
            self.delegate = self
            self.textAlignment = .left
            break
            
        case .showPassword :
            
            self.isSecureTextEntry = true
            self.returnKeyType = .default
            self.clearButtonMode = .never
            self.setShowToolbar(false)
            self.delegate = self
            self.textAlignment = .left
            break
            
        case .withoutClear :
            
            self.clearButtonMode = .never
            self.setShowToolbar(true)
            self.delegate = self
            self.textAlignment = .center
            break
            
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardAppearance = .dark
        
        self.autocapitalizationType = .none
        self.autocorrectionType = .default
        
        
        self.backgroundColor = Color.textFieldBG.value
        self.textColor = Color.textFieldText.value
        self.font = UIFont(name: FontStyle.medium, size: SystemConstants.IS_IPAD ? 17.0 : 13.0)
//        self.setBorder(Color.textFieldBorder.value,
//                       width: 1.5,
//                       radius: ControlLayout.borderRadius)
    }
    
    /**
     This method set the layout of textfield as per type.
     */
    func setlayout(){
        
        var baseLayout : AppBaseLayout!
        baseLayout = AppBaseLayout()
        
        baseLayout.viewDictionary = ["textField" : self]
        
        let textFieldHeight : CGFloat = currentDevice.isIpad ? 50.0 : 35.0
        let textFieldWidth : CGFloat = currentDevice.isIpad ? 40.0 : 50.0
        
        baseLayout.metrics = ["textFieldHeight" : textFieldHeight , "textFieldWidth" : textFieldWidth]
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[textField(textFieldHeight)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_V)
        
        switch type
        {
        case .showPassword:
            
            var btnShowPassword : UIButton! = UIButton(type: UIButton.ButtonType.custom)
            btnShowPassword.translatesAutoresizingMaskIntoConstraints = false
            btnShowPassword.backgroundColor = self.backgroundColor
            btnShowPassword .setImage(UIImage(named: "ShowPassword")?.maskWithColor(Color.appPrimaryBG.value), for: UIControl.State.normal)
            btnShowPassword .setImage(UIImage(named: "HidePassword")?.maskWithColor(Color.appPrimaryBG.value), for: UIControl.State.selected)
            btnShowPassword.imageEdgeInsets = SystemConstants.IS_IPAD ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            btnShowPassword .addTarget(self, action: #selector(self.btnShowPassword(sender:)), for: .touchUpInside)
            btnShowPassword .isSelected = true
            self.addSubview(btnShowPassword)
            
            baseLayout.viewDictionary = ["btnShowPassword" : btnShowPassword]
            baseLayout.metrics = ["buttonHeight" : textFieldHeight]
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnShowPassword]|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            baseLayout.position_Right = NSLayoutConstraint(item: btnShowPassword, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -5.0)
            baseLayout.size_Width = NSLayoutConstraint(item: btnShowPassword, attribute: .width, relatedBy: .equal, toItem: btnShowPassword, attribute: .height, multiplier: 1.0, constant: 0.0)
            
            self.addConstraint(baseLayout.size_Width)
            self.addConstraints(baseLayout.control_V)
            self.addConstraint(baseLayout.position_Right)
            btnShowPassword = nil
            break
            
        case .withoutClear:
            
            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[textField(textFieldWidth)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)
            break
            
        default:
            break
        }
        
        baseLayout.releaseObject()
        baseLayout = nil
    }
    
    
    // MARK: - Public Interface -
    /**
     Method for show the error border on textfield when user input invalide content.
     */
    func setErrorBorder(){
        self.setBorder(Color.textFieldErrorBorder.withAlpha(0.6), width: ControlLayout.txtBorderWidth, radius: ControlLayout.txtBorderRadius)
    }
    
    /**
     Method for remove the error border on textfield when user input valid content.
     */
    func clearErrorBorder(){
        self.setBorder(Color.textFieldErrorBorder.withAlpha(0.6), width: ControlLayout.txtBorderWidth, radius: ControlLayout.txtBorderRadius)
    }
    
    /**
     Method for reset the scrollview contentoff set zero when user fill whole form or stop the editing.
     */
    func resetScrollView(){
        
        AppUtility.executeTaskInGlobalQueueWithCompletion{ [weak self] in
            
            if self == nil{
                return
            }
            
            var scrollView : UIScrollView? = self!.getScrollViewFromView(self!)
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                    
                    if self == nil{
                        return
                    }
                    
                    scrollView?.setContentOffset(CGPoint.zero, animated: true)
                    self!.displayClearButton()
                    scrollView = nil
                }
            }
        }
    }
    
    /**
     Method for show the Navigation Toolbar on Keyword while in editing mode for navigation to next and preview textfield controll in Form.
     */
    func setShowToolbar(_ visible : Bool){
        
        if(visible){
            
            var fixedSpace : UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            fixedSpace.width = 5.0
            
            leftArrowButton = BaseBarButtonItem(itemType: .left)
            leftArrowButton.setTarget(self, action: #selector(leftArrowButtonAction))
            
            rightArrowButton = BaseBarButtonItem(itemType: .right)
            rightArrowButton.setTarget(self, action: #selector(rightArrowButtonAction))
            
            /*
             copyButton = BaseBarButtonItem(itemType: .BaseBarCopyButtonItemType)
             copyButton.setTarget(self, action: #selector(copyButtonAction))
             
             pasteButton = BaseBarButtonItem(itemType: .BaseBarPasteButtonItemType)
             pasteButton.setTarget(self, action: #selector(pasteButtonAction))
             
             self.addTarget(self, action: #selector(setCopyPasteEnabled), forControlEvents: .EditingChanged)
             */
            
            var doneButton : BaseBarButtonItem! = BaseBarButtonItem(itemType: .done)
            doneButton.setTarget(self, action: #selector(doneButtonAction))
            
            var flexibleSpace : UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            leftArrowButton.isEnabled = false
            rightArrowButton.isEnabled = false
            
            setCopyPasteEnabled()
            
            var numberToolbar : UIToolbar! = UIToolbar()
            numberToolbar.barStyle = .black
            numberToolbar.isTranslucent = false
            numberToolbar.barTintColor = Color.appPrimaryBG.value
            
            numberToolbar.tintAdjustmentMode = .normal
            numberToolbar.items = [leftArrowButton, fixedSpace, rightArrowButton, flexibleSpace, doneButton]
            numberToolbar.sizeToFit()
            self.inputAccessoryView = numberToolbar
            
            
            numberToolbar.setTopBorder(Color.textFieldBorder.withAlpha(General.textFieldColorAlpha), width: 1.0)
            numberToolbar.setBottomBorder(Color.textFieldBorder.withAlpha(General.textFieldColorAlpha), width: 1.0)
            
            do{
                doneButton = nil
                flexibleSpace = nil
                numberToolbar = nil
                fixedSpace = nil
            }
            
        }else{
            self.inputAccessoryView = nil
        }
        
    }
    
    /**
     This will show and Hide the ToolBar with done button on Keyboard
     */
    func setDoneToolbar(_ visible : Bool){
        
        if(visible){
            
            var flexibleSpace : UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            var doneButton : BaseBarButtonItem! = BaseBarButtonItem(itemType: .done)
            doneButton.setTarget(self, action: #selector(doneButtonAction))
            
            leftArrowButton.isEnabled = false
            rightArrowButton.isEnabled = false
            
            var numberToolbar : UIToolbar! = UIToolbar()
            
            numberToolbar.barStyle = .black
            numberToolbar.isTranslucent = false
            
            numberToolbar.barTintColor = Color.appPrimaryBG.value
            
            numberToolbar.tintAdjustmentMode = .normal
            numberToolbar.items = [flexibleSpace, doneButton]
            
            numberToolbar.sizeToFit()
            self.inputAccessoryView = numberToolbar
            
            numberToolbar.setTopBorder(Color.textFieldBorder.withAlpha(General.textFieldColorAlpha), width: 1.0)
            
            numberToolbar.setBottomBorder(Color.textFieldBorder.withAlpha(General.textFieldColorAlpha), width: 1.0)
            
            do{
                flexibleSpace = nil
                doneButton = nil
                numberToolbar = nil
            }
            
        }else{
            self.inputAccessoryView = nil
        }
    }
    
    // MARK: - User Interaction -
    @objc func leftArrowButtonAction(){
        self.setResponderToTextControl(.leftResponderDirectionType)
    }
    
    @objc func rightArrowButtonAction(){
        self.setResponderToTextControl(.rightResponderDirectionType)
    }
    
    func copyButtonAction(){
        
        if(self.hasText){
            UIPasteboard.general.string = self.text
        }
    }
    
    func pasteButtonAction(){
        if let string = UIPasteboard.general.string {
            self.insertText(string)
        }
    }
    
    @objc func doneButtonAction(){
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }
            self!.resignFirstResponder()
        }
        
        self.resetScrollView()
    }
    
    // MARK: - Internal Helpers -
    @objc func btnShowPassword(sender : UIButton) -> Void
    {
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.text = self.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        var button : UIButton! = sender
        button.isSelected = self.isSecureTextEntry
        button = nil
    }
    
    func setCopyPasteEnabled(){
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            if(self!.pasteButton != nil){
                self!.pasteButton.isEnabled = ((UIPasteboard.general.string?.count)! > 0)
            }
        }
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            if(self!.copyButton != nil){
                self!.copyButton.isEnabled = self!.hasText
            }
        }
    }
    
    func setScrollViewContentOffsetForView(_ view : UIView){
        
        AppUtility.executeTaskInGlobalQueueWithCompletion{ [weak self] in
            
            if self == nil{
                return
            }
            
            var scrollView : UIScrollView? = self!.getScrollViewFromView(self)
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                    
                    if self == nil{
                        return
                    }
                    
                    scrollView?.setContentOffset(CGPoint(x: 0.0, y: view.frame.origin.y), animated: true)
                    self!.displayClearButton()
                    scrollView = nil
                }
            }
        }
    }
    
    func getScrollViewFromView(_ view : UIView?) -> UIScrollView?{
        
        var scrollView : UIScrollView? = nil
        var view : UIView? = view!.superview!
        
        while (view != nil) {
            
            if(view!.isKind(of: UIScrollView.self)){
                scrollView = view as? UIScrollView
                break
            }
            
            if(view!.superview != nil){
                view = view!.superview!
                
            }else{
                view = nil
            }
        }
        return scrollView
    }
    
    /**
     Its used for check the Next and previous control is available or not in Form and Navigate to next and previeous controll as per user click on button.
     
     - iDirectionType: Direction for navigation to up or down
     
     */
    func setResponderToTextControl(_ iDirectionType : ResponderDirectionType){
        
        if(self.superview != nil && self.isEnabled){
            
            AppUtility.executeTaskInGlobalQueueWithCompletion{ [weak self] in
                
                if self == nil{
                    return
                }
                
                let subViewArray : Array! = (self!.superview?.subviews)!
                let subViewArrayCount : Int = subViewArray.count
                
                var isNextTextControlAvailable : Bool = false
                let currentTextFieldIndex : Int = subViewArray.firstIndex(of: self!)!
                
                var textField : UITextField?
                var textView : UITextView?
                
                var view : UIView?
                
                let operatorSign : Int = (iDirectionType == .leftResponderDirectionType) ? -1 : 1
                var i : Int = currentTextFieldIndex + operatorSign
                
                while(i >= 0 && i < subViewArrayCount){
                    
                    view = subViewArray[i]
                    isNextTextControlAvailable = view!.isKind(of: UITextField.self) || view!.isKind(of: UITextView.self)
                    
                    if(isNextTextControlAvailable){
                        
                        if(view!.isKind(of: UITextField.self)){
                            
                            textField = view as? UITextField
                            if(textField!.isEnabled && textField!.delegate != nil){
                                
                                AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                                    if self == nil{
                                        return
                                    }
                                    textField?.becomeFirstResponder()
                                }
                                break
                            }else{
                                isNextTextControlAvailable = false
                            }
                        }else if(view!.isKind(of: UITextView.self)){
                            
                            textView = view as? UITextView
                            if(textView!.isEditable && textView!.delegate != nil){
                                
                                AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                                    if self == nil{
                                        return
                                    }
                                    textView?.becomeFirstResponder()
                                }
                                break
                            }else{
                                isNextTextControlAvailable = false
                            }
                        }
                    }
                    i = i + operatorSign
                }
                
                if(isNextTextControlAvailable && view != nil){
                    self!.setScrollViewContentOffsetForView(view!)
                }
            }
        }
    }
    
    /**
     Display the Clear Button on TextField
     */
    func displayClearButton(){
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil{
                return
            }
            
            switch self!.type {
            case .showPassword , .withoutClear:
                
//                if self!.hasText{
//                    self!.clearButtonMode = .always
//                }else{
//                    self!.clearButtonMode = .whileEditing
//                }
                break
                
            default:
                break
            }
        }
    }
    
    // MARK: - UITextField Delegate Methods -
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        let isEditable = true
        return isEditable
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        self.setCopyPasteEnabled()
        self.setScrollViewContentOffsetForView(self)
        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            var scrollView : UIScrollView? = self!.getScrollViewFromView(self!)
            
            if(scrollView != nil)
            {
                AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                    if self == nil {
                        return
                    }
                    scrollView?.isScrollEnabled = false
                    scrollView = nil
                }
            }
            
            self!.displayClearButton()
            
            if(self!.superview != nil)
            {
                if(self!.leftArrowButton != nil)
                {
                    AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                        
                        if self == nil{
                            return
                        }
                        
                        let isEnabled : Bool = !BaseView.isFirstTextControlInSuperview(self!.superview, textControl: self!)
                        self!.leftArrowButton.isEnabled = isEnabled
                    }
                }
                
                if(self!.rightArrowButton != nil){
                    
                    AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                        
                        if self == nil{
                            return
                        }
                        
                        let isEnabled : Bool = !BaseView.isLastTextControlInSuperview(self!.superview, textControl: self!)
                        self!.rightArrowButton.isEnabled = isEnabled
                    }
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        self.setCopyPasteEnabled()
        
        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            var scrollView : UIScrollView? = self!.getScrollViewFromView(self!)
            
            if(scrollView != nil){
                
                AppUtility.executeTaskInMainQueueWithCompletion{ [weak self] in
                    
                    if self == nil{
                        return
                    }
                    scrollView?.isScrollEnabled = true
                    scrollView = nil
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            textField.resignFirstResponder()
            self!.resetScrollView()
        }
        return true
    }
    
    /**
     TextField delegate method for check the max character limit.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var oldlength : Int = 0
        if textField.text != nil
        {
            oldlength = (textField.text?.count)!
        }
        
        let replaceMentLength : Int = string.count
        let rangeLength : Int = range.length
        
        let newLength : Int = oldlength - rangeLength + replaceMentLength
        
        return newLength <= charaterLimit || false
    }
}


