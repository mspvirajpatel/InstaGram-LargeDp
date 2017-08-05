//
//  Localizator.swift
//  InstaLargerDp
//
//  Created by MacMini-2 on 22/04/17.
//  Copyright © 2017 WebMobTech-3. All rights reserved.
//

import UIKit

class Localizator: NSObject {
    static let sharedInstance = Localizator()
    
    lazy var localizableDictionary: NSDictionary! = {
        if let path = Bundle.main.path(forResource: "Localizable", ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        fatalError("Localizable file NOT found")
    }()
    
    func localize(string: String) -> String {
        guard let localizedString = localizableDictionary.value(forKey: string) else
        {
            assertionFailure("Missing translation for: \(string)")
            return ""
        }
        
        guard let localized = (localizedString as AnyObject).value(forKey: "value") as? String  else
        {
            assertionFailure("Missing translation for: \(string)")
            return ""
        }
        
        return localized
    }
}

extension String {
//    var localized: String {
//        return Localizator.sharedInstance.localize(string: self)
//    }
}
