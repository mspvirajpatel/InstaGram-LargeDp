//
//  BSApp.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 23/11/16.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import Foundation

/// Used to store the BFHasBeenOpened in defaults
private let BFHasBeenOpened = "BFHasBeenOpened"
/// Used to store the BFHasBeenOpenedForCurrentVersion in defaults
private let BFHasBeenOpenedForCurrentVersion = "\(BFHasBeenOpened)\(BSApp.version)"

// MARK: - Global functions -

/**
 Use BFLocalizedString to use the string translated by BFKit
 
 - parameter key:     The key string
 - parameter comment: An optional comment
 
 - returns: Returns the localized string
 */
public func BFLocalizedString(key: String, _ comment: String? = nil) -> String {
    return Bundle(for: BSApp.self).localizedString(forKey: key, value: key, table: "BFKit")
}

/**
 NSLocalizedString without comment parameter
 
 - parameter key: The key of the localized string
 
 - returns: Returns a localized string
 */
public func NSLocalizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

/// Get AppDelegate (To use it, cast to AppDelegate with "as! AppDelegate")
let APP_DELEGATE: UIApplicationDelegate? = UIApplication.shared.delegate

/// This class adds some useful functions for the App
public class BSApp {
    // MARK: - Class functions -
    
    /**
     Executes a block only if in DEBUG mode
     
     - parameter block: The block to be executed
     */
    public static func debugBlock(block: () -> ()) {
        #if DEBUG
            block()
        #endif
    }
    
    /**
     Executes a block on first start of the App.
     Remember to execute UI instuctions on main thread
     
     - parameter block: The block to execute, returns isFirstStart
     */
    public static func onFirstStart(block: (_ isFirstStart: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpened: Bool = defaults.bool(forKey: BFHasBeenOpened)
        if hasBeenOpened != true {
            defaults.set(true, forKey: BFHasBeenOpened)
            defaults.synchronize()
        }
        
        block(!hasBeenOpened)
    }
    
    /**
     Executes a block on first start of the App for current version.
     Remember to execute UI instuctions on main thread
     
     - parameter block: The block to execute, returns isFirstStartForCurrentVersion
     */
    public static func onFirstStartForCurrentVersion(block: (_ isFirstStartForCurrentVersion: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: BFHasBeenOpenedForCurrentVersion)
        if hasBeenOpenedForCurrentVersion != true {
            defaults.set(true, forKey: BFHasBeenOpenedForCurrentVersion)
            defaults.synchronize()
        }
        
        block(!hasBeenOpenedForCurrentVersion)
    }
    
    /**
     Executes a block on first start of the App for current given version.
     Remember to execute UI instuctions on main thread
     
     - parameter version: Version to be checked
     - parameter block:   The block to execute, returns isFirstStartForVersion
     */
    public static func onFirstStartForVersion(version: String, block: (_ isFirstStartForVersion: Bool) -> ()) {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForVersion: Bool = defaults.bool(forKey: BFHasBeenOpened + "\(version)")
        if hasBeenOpenedForVersion != true {
            defaults.set(true, forKey: BFHasBeenOpened + "\(version)")
            defaults.synchronize()
        }
        
        block(!hasBeenOpenedForVersion)
    }
    
    /// Returns if is the first start of the App
    public static var isFirstStart: Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpened: Bool = defaults.bool(forKey: BFHasBeenOpened)
        if hasBeenOpened != true {
            return true
        } else {
            return false
        }
    }
    
    /// Returns if is the first start of the App for current version
    public static var isFirstStartForCurrentVersion: Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: BFHasBeenOpenedForCurrentVersion)
        if hasBeenOpenedForCurrentVersion != true {
            return true
        } else {
            return false
        }
    }
    
    /**
     Returns if is the first start of the App for the given version
     
     - parameter version: Version to be checked
     
     - returns: Returns if is the first start of the App for the given version
     */
    public static func isFirstStartForVersion(version: String) -> Bool {
        let defaults = UserDefaults.standard
        let hasBeenOpenedForCurrentVersion: Bool = defaults.bool(forKey: BFHasBeenOpened + "\(version)")
        if hasBeenOpenedForCurrentVersion != true {
            return true
        } else {
            return false
        }
    }
}

public extension BSApp {
    
    public static var name: String = { return BSApp.string(forKey: "CFBundleName") }()
    public static var version: String = { return BSApp.string(forKey: "CFBundleShortVersionString") }()
    public static var build: String = { return BSApp.string(forKey: "CFBundleVersion") }()
    public static var executable: String = { return BSApp.string(forKey: "CFBundleExecutable") }()
    public static var bundle: String = { return BSApp.string(forKey: "CFBundleIdentifier") }()
    
    private static func string(forKey key: String) -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let value = infoDictionary[key] as? String else { return "" }
        
        return value
    }
}
