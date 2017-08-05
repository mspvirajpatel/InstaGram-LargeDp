//
//  PListManager.swift
//
//  Created by SamSol on 01/07/16.
//  Copyright © 2016 SamSol. All rights reserved.
//

import UIKit

class PListManager: NSObject {
    
    // MARK: - Attributes -

    var filePath: String!

    // MARK: - Lifecycle -
    
    convenience init(fileName: String){
        self.init()
        
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // MARK: - Public Interface -
    
    func readFromPlist(_ fileName : String) -> AnyObject
    {
        let paths = Bundle.main.path(forResource: fileName, ofType: "plist")
        print(paths!)
        
        var plistData : AnyObject!
        
        do {
            let fileData : Data = try Data(contentsOf: URL(fileURLWithPath: paths!))
            
            plistData = try PropertyListSerialization .propertyList(from: fileData, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as AnyObject!
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return plistData
    }

    
    
    
    // MARK: - Internal Helpers -
    
    func createPlistFromFileName(_ fileName: String){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName + ".plist")
        
        print(path)
        
        let fileManager = FileManager.default
        
        //check if file exists
        if(!fileManager.fileExists(atPath: path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "plist") {
                
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
                } catch _ {
                    
                }
                print("copy")
            } else {
                print("plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            
//            do {
//                try   fileManager.removeItem(atPath: path)
//            } catch _ {
//                
//            }
//          
//            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "plist") {
//                
//                do {
//                    try fileManager.copyItem(atPath: bundlePath, toPath: path)
//                } catch _ {
//                    
//                }
//                print("copy")
//            } else {
//                print("plist not found. Please, make sure it is part of the bundle.")
//            }
           
            print("plist already exits at path.")
           
        }
        
    }
    
    func savePlistData(_ fileName: String, parametres: NSDictionary) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName + ".plist")
        
        //writing to plist
        parametres.write(toFile: path, atomically: false)
        
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved plist file is --> \(resultDictionary?.description)")
    }
    
    func savePlistArray(_ fileName: String, parametres: NSArray) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(fileName + ".plist")
        
        //writing to plist
        parametres.write(toFile: path, atomically: false)
        
        let resultDictionary = NSArray(contentsOfFile: path)
        print("Saved plist file is --> \(resultDictionary?.description)")
    }
    
    
   
    
}
