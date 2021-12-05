//
//  BaseImageView.swift
//  ViewControllerDemo
//
//  Created by VirajPatel on 01/07/16.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import Kingfisher

/**
 This is list of ImageView Type which are define in BaseImageView Class. We can add new type in this and handle in BaseImageView.
 */
enum BaseImageViewType : Int {
    
    case unknown = -1
    case profile = 1
    case logo = 2
    case defaultImg = 3
}

/**
 This class used to Create ImageView object and set image. We can use used this class as base ImageView in Whole Application.
 */
class BaseImageView: UIImageView {
    
    // MARK: - Attributes -
    
    /// Its type Of ImageView. Default is unknown
    var imageViewType : BaseImageViewType = .unknown
    
    /// Its progress indicatorview, which can used to show image downloding process from network.
    var progressIndicatorView : CircularLoaderView! = CircularLoaderView(frame: CGRect.zero)
   
    @IBInspectable
    var fadeDuration: Double = 0.33
    
    override var image: UIImage? {
        get {
            return super.image
        }
        set(newImage) {
            if let img = newImage {
                CATransaction.begin()
                CATransaction.setAnimationDuration(self.fadeDuration)
                
                let transition = CATransition()
                transition.type = CATransitionType.fade
                
                super.layer.add(transition, forKey: kCATransition)
                super.image = img
                
                CATransaction.commit()
            } else {
                super.image = nil
            }
        }
    }
    
    
    // MARK: - Lifecycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /**
     Its Initialize method of BaseImageView.
     - parameter type its type of imageview like profile,logo etc..
     - parameter superView its object of imageView's superView. Its can be null. When it's not null than imageview will added as subview in SuperView object
     */
    init(type : BaseImageViewType, superView: UIView?) {
        super.init(frame: CGRect.zero)
        
        imageViewType = type
        
        self.setCommonProperties()
        self.setlayout()
        
        if(superView != nil){
            superView?.addSubview(self)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)!
        
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        switch imageViewType {
        case .defaultImg:
            
            break
        default:
            break
        }
    }
    
    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit{
        progressIndicatorView = nil
    }
    
    // MARK: - Layout -
    /**
     This method is used to Set the Common proparty of ImageView as per Type like ContentMode,Border,tag,Backgroud color etc...
     */
    func setCommonProperties(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        switch imageViewType {
            
        case BaseImageViewType.profile:
            
            self.contentMode = .scaleAspectFit
            self.layoutSubviews()
            addSubview(self.progressIndicatorView)
            
            break
            
        case BaseImageViewType.logo:
            
            self.image = UIImage(named: "App_icon")!
            
            self.contentMode = .scaleAspectFit
            self.setBorder(Color.border.withAlpha(0.5), width: 0.0, radius: 2.0)
            self.clipsToBounds = true
            self.tag = 0
            self.isUserInteractionEnabled = true
            self.translatesAutoresizingMaskIntoConstraints = false
            
            break;
            
        case BaseImageViewType.defaultImg:
            
            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
            self.translatesAutoresizingMaskIntoConstraints = false
            addSubview(self.progressIndicatorView)
            break
            
        default:
            break
        }
        
    }
    
    /// This method is used to Set the layout related things as per type like ImageView Height, width etc..
    func setlayout(){
        
        
    }
    
    // MARK: - Public Interface -
    
    func displayImageFromURL(_ urlString : String, placeholder : UIImage? = UIImage(named: "postplaceholder")) {
        self.kf.indicatorType = .activity
        self.kf.indicator?.startAnimatingView()
        let imageURL : URL? = URL(string: urlString)
        
        self.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                // Done
                self.kf.indicator?.stopAnimatingView()
                switch result {
                case .success(let value):
                    self.image = value.image
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            });
        
        self.layoutSubviews()
        
    }
    
    func displayImageFromUrmwithComplition(_ urlString : String, completion : @escaping (_ success : Bool, _ image : UIImage?) -> Void) {
        self.kf.indicatorType = .activity
        self.kf.indicator?.startAnimatingView()
        
        let imageURL : URL? = URL(string: urlString)
        
        self.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "postplaceholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                // Done
                self.kf.indicator?.stopAnimatingView()
                switch result {
                case .success(let value):
                    self.image = value.image
                    completion(true, self.image)
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    completion(false, nil)
                    print("Job failed: \(error.localizedDescription)")
                }
            });
    }
    
    func displayImageFromURLWithAppLable(_ urlString : String) {
        
        self.kf.indicatorType = .activity
        self.kf.indicator?.startAnimatingView()
        let imageURL : URL? = URL(string: urlString)
        
        self.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "postplaceholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                // Done
                self.kf.indicator?.stopAnimatingView()
                switch result {
                case .success(let value):
                    self.image = value.image.editWithText(text: "@\(AppName)")
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            });
        
        self.layoutSubviews()
        
    }
    
    func displayImageFromURLWithUsername(_ urlString : String, _ username: String) {
        
        self.kf.indicatorType = .activity
        self.kf.indicator?.startAnimatingView()
        let imageURL : URL? = URL(string: urlString)
        
        self.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "postplaceholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ],
            progressBlock: { receivedSize, totalSize in
                // Progress updated
            },
            completionHandler: { [weak self] result in
                guard let `self` = self else {
                    return
                }
                // Done
                self.kf.indicator?.stopAnimatingView()
                switch result {
                case .success(let value):
                    
                    let hie : Int = Int((value.image.size.height))
                    if hie < 640 {
                        let images : UIImage = value.image.scaled(to: CGSize.init(width: 640, height: 640), scalingMode: .aspectFill)
                        self.image = images.editWithText(text: "@\(username)")
                    }
                    else
                    {
                        self.image = value.image.editWithText(text: "@\(username)")
                    }
                    
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            });
        
        self.layoutSubviews()
        
        
    }

    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
}

extension UIImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

