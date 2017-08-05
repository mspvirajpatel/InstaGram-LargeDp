//
//	RootClass.swift
//
//	Create by MacMini-2 on 11/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ValidateLogin : NSObject, NSCoding{

	var authenticated : Bool! = false
	var status : String! = ""
	var user : Bool! = false


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any])
    {
        if let data = dictionary["authenticated"] as? Bool {
            authenticated = data
        }
        
        if let data = dictionary["status"] as? String {
            status = data
        }
        
        if let data = dictionary["user"] as? Bool {
            user = data
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if authenticated != nil{
			dictionary["authenticated"] = authenticated
		}
		if status != nil{
			dictionary["status"] = status
		}
		if user != nil{
			dictionary["user"] = user
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         authenticated = aDecoder.decodeObject(forKey: "authenticated") as? Bool
         status = aDecoder.decodeObject(forKey: "status") as? String
         user = aDecoder.decodeObject(forKey: "user") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if authenticated != nil{
			aCoder.encode(authenticated, forKey: "authenticated")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}
