//
//	SearchModel.swift
//
//	Create by VirajPatel on 8/4/2017
//	Copyright © 2017. All rights reserved.

import Foundation


class SearchModel : NSObject, NSCoding{
    
    var hasMore : Bool! = false
    var status : String! = ""
    var users : [SearchUser]! = []
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any])
    {
        if let data = dictionary["has_more"] as? Bool {
            hasMore = data
        }
    
        if let data = dictionary["status"] as? String {
            status = data
        }

        users = [SearchUser]()
        if let usersArray = dictionary["users"] as? [[String:Any]]{
            for dic in usersArray{
                let value = SearchUser(fromDictionary: dic)
                users.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if hasMore != nil{
            dictionary["has_more"] = hasMore
        }
       
        if status != nil{
            dictionary["status"] = status
        }
        if users != nil{
            var dictionaryElements = [[String:Any]]()
            for usersElement in users {
                dictionaryElements.append(usersElement.toDictionary())
            }
            dictionary["users"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        hasMore = aDecoder.decodeObject(forKey: "has_more") as? Bool
        status = aDecoder.decodeObject(forKey: "status") as? String
        users = aDecoder.decodeObject(forKey :"users") as? [SearchUser]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if hasMore != nil{
            aCoder.encode(hasMore, forKey: "has_more")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if users != nil{
            aCoder.encode(users, forKey: "users")
        }
        
    }
    
}


