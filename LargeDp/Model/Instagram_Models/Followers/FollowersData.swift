//
//	FollowersData.swift
//
//	Create by MacMini-2 on 13/4/2017
//	Copyright © 2017. All rights reserved.

import Foundation

class FollowersData : NSObject, NSCoding{

	var user : FollowersUser!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let userData = dictionary["user"] as? [String:Any]{
			user = FollowersUser(fromDictionary: userData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if user != nil{
			dictionary["user"] = user.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         user = aDecoder.decodeObject(forKey: "user") as? FollowersUser

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}
