//
//	From.swift
//
//	Create by VirajPatel on 8/4/2017
//	Copyright © 2017. All rights reserved.
 

import Foundation


class From : NSObject, NSCoding{

	var fullName : String! = ""
	var id : String! = ""
	var profilePicture : String! = ""
	var username : String! = ""


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any])
    {
        if let data = dictionary["full_name"] as? String{
            fullName = data
        }
        
        if let data = dictionary["id"] as? String {
            id = data
        }
        
        if let data = dictionary["profile_picture"] as? String {
            profilePicture = data
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
		if fullName != nil{
			dictionary["full_name"] = fullName
		}
		if id != nil{
			dictionary["id"] = id
		}
		if profilePicture != nil{
			dictionary["profile_picture"] = profilePicture
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
         fullName = aDecoder.decodeObject(forKey: "full_name") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         profilePicture = aDecoder.decodeObject(forKey: "profile_picture") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if fullName != nil{
			aCoder.encode(fullName, forKey: "full_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if profilePicture != nil{
			aCoder.encode(profilePicture, forKey: "profile_picture")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}

	}

}
