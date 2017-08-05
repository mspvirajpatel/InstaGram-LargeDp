//
//	User.swift
//
//	Create by MacMini-2 on 11/4/2017
//	Copyright © 2017. All rights reserved.
 

import Foundation


class TimeLineUser : NSObject, NSCoding{

	var id : String! = ""
	var profilePicUrl : String! = ""
	var username : String! = ""


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any])
    {
        if let data = dictionary["id"] as? String {
            id = data
        }
        
        if let data = dictionary["profile_pic_url"] as? String {
            profilePicUrl = data
        }
        
        if let data = dictionary["username"] as? String {
            username = data
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		
		if id != nil{
			dictionary["id"] = id
		}
		if profilePicUrl != nil{
			dictionary["profile_pic_url"] = profilePicUrl
		}
		if username != nil{
			dictionary["username"] = username
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "id") as? String
         profilePicUrl = aDecoder.decodeObject(forKey: "profile_pic_url") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if profilePicUrl != nil{
			aCoder.encode(profilePicUrl, forKey: "profile_pic_url")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}

	}

}
