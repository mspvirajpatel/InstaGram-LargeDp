/**
 This is Base Class of TextView.
 
 - placeholder: Placeholder String of uitextview.
 - placeHolderLabel: Object of PlaceHolder Label.
 - borderView: Its show the Border on uitextview
 - leftArrowButton: Object of left Arrao button when keyboard will show
 - rightArrowButton: Object of Right Arraw button when keyboard will show
 - isMultiLinesSupported: Boolian value for set the Multiline support in TextView
 */

import UIKit

class BaseTextView: UITextView, UITextViewDelegate, UIScrollViewDelegate {
    
    // MARK: - Attributes -
    var placeholder : String!
    var placeHolderLabel : UILabel!
    var borderView : UIView!
    var leftArrowButton : BaseBarButtonItem!
    var rightArrowButton : BaseBarButtonItem!
    var isMultiLinesSupported : Bool = false
    
    // MARK: - Lifecycle -
    init(iSuperView: UIView?) {
        super.init(frame: CGRect.zero, textContainer: nil)
        
        self.setCommonProperties()
        self.setlayout()
        
        if(iSuperView != nil){
            iSuperView!.addSubview(self)
            self.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
    }
    /**
     Here we override the Draw rect method of UITextView for set the Placeholder Label in TextView.
     */
    override func draw(_ rect: CGRect) {
        superview?.draw(rect)
        
        if self.placeholder == nil {
            return
        }
        
        if(self.placeholder.characters.count > 0){
            
            if(placeHolderLabel == nil){
                
                placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 6, width: self.bounds.size.width - 16, height: 0))
                
                placeHolderLabel.lineBreakMode = .byWordWrapping
                placeHolderLabel.numberOfLines = 0
                
                placeHolderLabel.font = self.font
                placeHolderLabel.backgroundColor = UIColor.clear
                
                placeHolderLabel.textColor = Color.textFieldPlaceholder.withAlpha(0.45)
                placeHolderLabel.alpha = 0.0
                
                placeHolderLabel.tag = 999
                self.addSubview(placeHolderLabel)
            }
            
            placeHolderLabel.text = self.placeholder
            placeHolderLabel.sizeToFit()
            
            self.sendSubview(toBack: placeHolderLabel)
            
        }
        
        if(self.text!.characters.count == 0 && self.placeholder.characters.count > 0){
            self.viewWithTag(999)?.alpha = 1
        }
        
    }
    
    override var text: String?{
        didSet{
            self.textViewDidChange(self)
        }
    }
    
    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit{
        
        //  baseLayout = nil
        placeholder = nil
        
        placeHolderLabel = nil
        borderView = nil
        
        leftArrowButton = nil
        rightArrowButton = nil
    }
    
    // MARK: - Layout -
    /// Its will set the commond properties of TextView  like background color,EdgeInsets of Text,Key type,font etc...
    func setCommonProperties(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        self.autocapitalizationType = .sentences
        self.autocorrectionType = .default
        self.keyboardAppearance = .dark
        self.textColor = Color.textFieldText.value
        self.backgroundColor = Color.textFieldBG.value
        self.font = UIFont(name: FontStyle.medium, size: SystemConstants.IS_IPAD ? 17.0 : 13.0)
        //self.setShowToolbar(true)
        //self.setBorder(Color.textFieldBorder.value, width: 1.5, radius: ControlLayout.borderRadius)
    }
    
    func setlayout(){
        
        
    }
    
    // MARK: - Public Interface -
    /// Method for show the error on textview
    func setErrorBorder(){
        self.setBorder(Color.textFieldErrorBorder.withAlpha(0.45), width: ControlLayout.txtBorderWidth, radius: ControlLayout.txtBorderRadius)
    }
    
    /// method for reset the scrollview content off when keyboard close or done button clicked.
    func resetScrollView(){
        
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
                    
                    scrollView?.setContentOffset(CGPoint.zero, animated: true)
                    scrollView = nil
                }
            }
        }
    }
    
    /// Method for show/Hide the Toolbar with done,Up and Down arrow button on keyboard.
    func setShowToolbar(_ visible : Bool){
        
        if(visible){
            
            var fixedSpace : UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            fixedSpace.width = 5.0
            
            leftArrowButton = BaseBarButtonItem(itemType: .left)
            leftArrowButton.setTarget(self, action: #selector(leftArrowButtonAction))
            
            rightArrowButton = BaseBarButtonItem(itemType: .right)
            rightArrowButton.setTarget(self, action: #selector(rightArrowButtonAction))
            
            var doneButton : BaseBarButtonItem! = BaseBarButtonItem(itemType: .done)
            doneButton.setTarget(self, action: #selector(doneButtonAction))
            
            var flexibleSpace : UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            leftArrowButton.isEnabled = false
            rightArrowButton.isEnabled = false
            
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
            
            defer{
                fixedSpace = nil
                doneButton = nil
                flexibleSpace = nil
                numberToolbar = nil
            }
            
        }else{
            self.inputAccessoryView = nil
        }
    }
    
    /// Method for show/Hide the Toolbar with done,Up and Down arrow button on keyboard.
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
            
            defer{
                flexibleSpace = nil
                doneButton = nil
                numberToolbar = nil
            }
        }
        else
        {
            self.inputAccessoryView = nil
        }
    }
    
    func setHideBottomBorder(_ hidden : Bool){
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil{
                return
            }
            self!.borderView.isHidden = hidden
        }
    }
    
    // MARK: - User Interaction -
    
    func leftArrowButtonAction(){
        self.setResponderToTextControl(.leftResponderDirectionType)
    }
    
    func rightArrowButtonAction(){
        self.setResponderToTextControl(.rightResponderDirectionType)
    }
    
    func doneButtonAction(){
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil{
                return
            }
            self!.resignFirstResponder()
        }
        
        self.resetScrollView()
    }
    
    // MARK: - Internal Helpers -
    
    func setScrollViewContentOffsetForView(_ view : UIView){
        
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
                    scrollView?.setContentOffset(CGPoint(x: 0.0, y: view.frame.origin.y), animated: true)
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
            }
            else{
                view = nil
            }
        }
        return scrollView
    }
    
    func setResponderToTextControl(_ iDirectionType : ResponderDirectionType){
        
        if(self.superview != nil && self.isEditable){
            
            AppUtility.executeTaskInGlobalQueueWithCompletion{ [weak self] in
                
                if self == nil{
                    return
                }
                
                var subViewArray : Array! = (self!.superview?.subviews)!
                let subViewArrayCount : Int = subViewArray!.count
                
                var isNextTextControlAvailable : Bool = false
                let currentTextFieldIndex : Int = subViewArray.index(of: self!)!
                
                var textField : UITextField?
                var textView : UITextView?
                
                var view : UIView?
                
                let operatorSign = (iDirectionType == .leftResponderDirectionType) ? -1 : 1
                var i = currentTextFieldIndex + operatorSign
                
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
                subViewArray = nil
                textView = nil
                textField = nil
            }
        }
    }
    
    // MARK: - UITextView Delegate Methods -
    
    func textViewDidChange(_ textView: UITextView){
        if(self.placeholder.characters.count == 0){
            return
        }
        
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            
            if self == nil{
                return
            }
            
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                
                if self == nil{
                    return
                }
                
                if(!self!.hasText){
                    self!.viewWithTag(999)?.alpha = 1.0
                    
                }else{
                    self!.viewWithTag(999)?.alpha = 0.0
                }
            })
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        
        self.setScrollViewContentOffsetForView(self)
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
                    scrollView?.isScrollEnabled = false
                    scrollView = nil
                }
            }
            
            if(self!.superview != nil){
                
                if(self!.leftArrowButton != nil){
                    
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
    
    func textViewDidEndEditing(_ textView: UITextView){
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        if(text == "\n" && !self.isMultiLinesSupported){
            
            textView.resignFirstResponder()
            self.resetScrollView()
            
            return false
        }
        
        return true
    }
    
    
    // MARK: - UIScrollView Delegate Methods -
    
    func scrollViewDidScroll(_ scrollView : UIScrollView){
        self.layoutSubviews()
    }
    
}
