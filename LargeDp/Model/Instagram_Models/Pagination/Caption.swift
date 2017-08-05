//
//	Caption.swift
//
//	Create by MacMini-2 on 8/4/2017
//	Copyright © 2017. All rights reserved.
 

import Foundation


class Caption : NSObject, NSCoding{

	var createdTime : String! = ""
	var from : From!
	var id : String! = ""
	var text : String! = ""


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
        
        if let data = dictionary["created_time"] as? String {
            createdTime = data
        }
        
        if let data = dictionary["id"] as? String {
            id = data
        }
        
        if let data = dictionary["text"] as? String {
            text = data
        }
        
		if let fromData = dictionary["from"] as? [String:Any]{
			from = From(fromDictionary: fromData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if createdTime != nil{
			dictionary["created_time"] = createdTime
		}
		if from != nil{
			dictionary["from"] = from.toDictionary()
		}
		if id != nil{
			dictionary["id"] = id
		}
		if text != nil{
			dictionary["text"] = text
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createdTime = aDecoder.decodeObject(forKey: "created_time") as? String
         from = aDecoder.decodeObject(forKey: "from") as? From
         id = aDecoder.decodeObject(forKey: "id") as? String
         text = aDecoder.decodeObject(forKey: "text") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if createdTime != nil{
			aCoder.encode(createdTime, forKey: "created_time")
		}
		if from != nil{
			aCoder.encode(from, forKey: "from")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}

	}

}
