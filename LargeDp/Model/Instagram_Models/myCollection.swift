//
//  myCollection.swift
//  InstaLargerDp
//
//  Created by VirajPatel on 26/04/17.
//  Copyright © 2017 VirajPatel. All rights reserved.
//

import UIKit
import GRDB

class myCollection: Record {
   
    var id: Int! = 0
    var modelType: Int! = 0
    var data: String! = ""
    var loginUserID: String! = ""
    var modelID: String! = ""
    var timeStamp : String! = ""
    var isFavorite: Int! = 0
    var isRecent: Int! = 1
    
    // MARK: Record overrides
    
    override class var databaseTableName: String {
        return "myCollection"
    }
    
    override init() {
        super.init()
    }
    
    init(fromDictionary dictionary: [String:Any]){
        super.init()
       
        id = dictionary["id"] as! Int
        modelType =  dictionary["modelType"] as! Int
        data =  dictionary["data"] as! String
        modelID =  dictionary["modelID"] as! String
        timeStamp =  dictionary["timeStamp"] as! String
        loginUserID =  dictionary["loginUserID"] as! String
        
        isFavorite = dictionary["isFavorite"] as! Int
        isRecent = dictionary["isRecent"] as! Int
    }
    
    required init(row: Row) {
//        id = row.value(named: "id")
//        modelType = row.value(named: "modelType")
//        data = row.value(named: "data")
//        loginUserID = row.value(named: "loginUserID")
//        modelID = row.value(named: "modelID")
//        timeStamp = row.value(named: "timeStamp")
//        isFavorite = row.value(named: "isFavorite")
//        isRecent = row.value(named: "isRecent")
        
        super.init(row: row)
    }
    
    var persistentDictionary: [String : DatabaseValueConvertible?] {
        return [
            "id": id,
            "modelType": modelType,
            "data": data,
            "loginUserID": loginUserID,
            "modelID": modelID,
            "timeStamp": timeStamp,
            "isFavorite": isFavorite,
            "isRecent": isRecent
        ]
    }
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if modelType != nil{
            dictionary["modelType"] = modelType
        }
        
        if data != nil{
            dictionary["data"] = data
        }
        
        if loginUserID != nil{
            dictionary["loginUserID"] = loginUserID
        }
        
        if modelID != nil{
            dictionary["modelID"] = modelID
        }
        
        if timeStamp != nil{
            dictionary["timeStamp"] = timeStamp
        }
        
        if isFavorite != nil{
            dictionary["isFavorite"] = isFavorite
        }
        
        if isRecent != nil{
            dictionary["isRecent"] = isRecent
        }
        
        return dictionary
    }

    
}
