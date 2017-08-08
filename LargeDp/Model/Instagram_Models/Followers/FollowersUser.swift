//
//	FollowersUser.swift
//
//	Create by VirajPatel on 13/4/2017
//	Copyright © 2017. All rights reserved.

import Foundation


class FollowersUser : NSObject, NSCoding{

	var edgeFollow : EdgeFollow!
    var edgeFollowedBy : EdgeFollowedBy!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let edgeFollowData = dictionary["edge_follow"] as? [String:Any]{
			edgeFollow = EdgeFollow(fromDictionary: edgeFollowData)
		}
        if let edgeFollowedByData = dictionary["edge_followed_by"] as? [String:Any]{
            edgeFollowedBy = EdgeFollowedBy(fromDictionary: edgeFollowedByData)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if edgeFollow != nil{
			dictionary["edge_follow"] = edgeFollow.toDictionary()
		}
        if edgeFollowedBy != nil{
            dictionary["edge_followed_by"] = edgeFollowedBy.toDictionary()
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         edgeFollow = aDecoder.decodeObject(forKey: "edge_follow") as? EdgeFollow
        edgeFollowedBy = aDecoder.decodeObject(forKey: "edge_followed_by") as? EdgeFollowedBy
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if edgeFollow != nil{
			aCoder.encode(edgeFollow, forKey: "edge_follow")
		}
        if edgeFollowedBy != nil{
            aCoder.encode(edgeFollowedBy, forKey: "edge_followed_by")
        }

	}

}
