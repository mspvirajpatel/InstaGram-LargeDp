//
//  DatabaseManager.swift
//  CamLive
//
//  Created by WebMob on 24/02/17.
//  Copyright © 2017 WebMobTech. All rights reserved.
//

import GRDB
import UIKit



class DatabaseManager: NSObject
{
    static let sharedInstance : DatabaseManager = DatabaseManager.init()
    
    var migration : DatabaseMigrator!
    var dbQueue: DatabaseQueue!

    private override init(){
        super.init()
    }
    
    // MARK: Initial SetUp method
    func setUpDatabase(_ application : UIApplication) throws -> Void {
        
        // Connect to Database
        let documentPath : NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let databasePath : NSString = documentPath.appendingPathComponent("InstaLargeDp.sqlite") as NSString
        
        dbQueue = try DatabaseQueue(path: databasePath as String)
        
        print(databasePath)
        // Memoery management
        dbQueue.setupMemoryManagement(in: application)
        
        migration = DatabaseMigrator()
        
        try self.createTableForIntialSetup()
    }
    
    // MARK: Table Create metohds
    private func createTableForIntialSetup() throws{
        
        migration.registerMigration("version1") { (db) in
            
            try db.create(table: "myCollection", body: { (t) in
                
                t.column("id", .integer).primaryKey()
                t.column("modelType", .integer).notNull()
                t.column("data", .text).notNull()
                t.column("modelID",.text).notNull()
                t.column("timeStamp",.text).notNull().defaults(sql: String(Date().timeIntervalSince1970))
                t.column("loginUserID",.text).notNull().defaults(sql: "0")
                t.column("isFavorite",.integer).notNull().defaults(to: 0)
                t.column("isRecent",.integer).notNull().defaults(to: 1)
            })
            
        }
        
        try migration.migrate(dbQueue)
    }
    
    // MARK: Data Insertion operation Method
//    internal func insertModel(data : String,type : Int) throws -> Void{
//        try dbQueue.inDatabase({ (db) throws in
//            try db.execute("INSERT INTO myCollection (modelType,data) VALUES(:modelType, :data)", arguments: ["modelType":type,"data" : data])
//        })
//    }
    
    internal func isCollectionAdded(collectionId : String,completion : (_ exists : Bool) -> Void) throws -> Void
    {
        completion(false)
        do{
            //let userID : String = AppUtility.getLoginUserID()
            try dbQueue.inDatabase({ (db) throws in
                let rows = try Row.fetchCursor(db,"SELECT modelID from myCollection where modelID = '\(collectionId)' AND isFavorite = 1")
                if try rows.next() != nil{
                    completion(true)
                }
                else{
                    completion(false)
                }
            })
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    internal func removeAddedCollection(collectionId : String,completion : (_ isSuccess : Bool) -> Void) throws -> Void{
        completion(false)
        
        try dbQueue.inDatabase({ (db) throws in
            do{
               // let userID : String = AppUtility.getLoginUserID()
                
                try db.execute("DELETE FROM myCollection WHERE modelID = '\(collectionId)'")
                completion(true)
                //AppUtility.showWhisperAlert(message: "removeimage".localize(), duration: 3)
            }
            catch let error as NSError{
                print(error.localizedDescription)
                completion(false)
            }
        })
    }
    
    internal func removeAddedRecent(completion : (_ isSuccess : Bool) -> Void) throws -> Void{
        completion(false)
        
        try dbQueue.inDatabase({ (db) throws in
            do{
               
                try myCollection.filter(Column("isFavorite") == 0).deleteAll(db)
  
                completion(true)
                
                //AppUtility.showWhisperAlert(message: "removeimage".localize(), duration: 3)
            }
            catch let error as NSError{
                print(error.localizedDescription)
                completion(false)
            }
        })
    }

    
    internal func insertModel(data : String,type : Int,modelId : String,timeStamp : String,isFavorite : Int) throws -> Void{
        
        let loginUserID = AppUtility.getLoginUserID()
      
        try dbQueue.inDatabase({ (db) throws in
          
            let rows = try myCollection.fetchAll(db, "SELECT * FROM myCollection WHERE modelID = '\(modelId)'")
            
            if rows.count != 0
            {
                rows[0].modelType = type
                rows[0].modelID = modelId
                rows[0].data = data
                
                if rows[0].isFavorite == 0
                {
                    rows[0].isFavorite = isFavorite
                    rows[0].timeStamp = timeStamp
                }
                else if rows[0].isFavorite == 1
                {
                   
                }
                
                try rows[0].update(db)
            }
            else
            {
                try db.execute("INSERT INTO myCollection (modelType,data,modelID,timeStamp,loginUserID,isFavorite) VALUES(:modelType, :data,:modelID,:timeStamp,:loginUserID,:isFavorite)", arguments: ["modelType":type,"data" : data,"modelID":modelId,"timeStamp":timeStamp,"loginUserID" : loginUserID,"isFavorite":isFavorite])
                
            }
        })
    }
    
    
    // MARK: Data Retriav Operation Method
    internal func getMyFavourite(completion : (_ objectModel : [AnyObject]) -> Void) throws -> Void{
        
        try dbQueue.inDatabase({ (db) throws in
            do{
                let arrModel = try myCollection.fetchAll(db, "SELECT * FROM myCollection  WHERE isFavorite = 1 ORDER BY timeStamp DESC")
                completion(arrModel)
               
            }
            catch let error as NSError{
                print(error.localizedDescription)
                completion([])
            }
        })
    }
    
    internal func getModel(completion : (_ models : [AnyObject]) -> Void) throws -> Void{
        try dbQueue.inDatabase({ (db) throws in
            do{
                let loginUserID : String = AppUtility.getLoginUserID()
                
                let rows = try Row.fetchCursor(db, "SELECT modelType,data,isFavorite from myCollection WHERE loginUserID = \(loginUserID) ORDER BY timestamp ASC")
                
                var arrModel : [AnyObject] = []
                while let row = try rows.next(){
                    
                    if let data : String = row.value(named: "data") as? String
                    {
                        if let dicData : NSDictionary = data.dictionary()
                        {
                            var type : Int = -1
                            if let modelType = row.value(named: "modelType") as? Int
                            {
                                type = modelType
                            }
                            else if let modelType = row.value(named: "modelType") as? Int64{
                                type = Int(modelType)
                            }
                            else if let modelType = row.value(named: "modelType") as? String{
                                type = Int(modelType)!
                            }
                            
                            switch type
                            {
                            case ImageEditorViewType.follow.rawValue:
                                
                                arrModel.append(FollowersEdge(fromDictionary: dicData as! [String : AnyObject]))
                                break
                                                            
                            default:
                                break
                            }
                        }
                    }
                }
                completion(arrModel)
            }
            catch let error as NSError{
                print(error.localizedDescription)
                completion([])
            }
        })
    }
    
    
    // MARK: Data Updation operation Method
    
    
    // MARK: Data Delete opration Method
    
}
