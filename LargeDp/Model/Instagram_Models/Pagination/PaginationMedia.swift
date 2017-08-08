//
//	RootClass.swift
//
//	Create by VirajPatel on 8/4/2017
//	Copyright © 2017. All rights reserved.
 

import Foundation


class PaginationMedia : NSObject, NSCoding{

	var items : [Item]! = []
    var moreAvailable : Bool! = false
	var status : String! = ""


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		items = [Item]()
		if let itemsArray = dictionary["items"] as? [[String:Any]]{
			for dic in itemsArray{
				let value = Item(fromDictionary: dic)
				items.append(value)
			}
		}
        
        if let data = dictionary["more_available"] as? Bool
        {
            moreAvailable = data
        }
        
        if let data = dictionary["status"] as? String{
            status = data
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if items != nil{
			var dictionaryElements = [[String:Any]]()
			for itemsElement in items {
				dictionaryElements.append(itemsElement.toDictionary())
			}
			dictionary["items"] = dictionaryElements
		}
		if moreAvailable != nil{
			dictionary["more_available"] = moreAvailable
		}
		if status != nil{
			dictionary["status"] = status
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         items = aDecoder.decodeObject(forKey :"items") as? [Item]
         moreAvailable = aDecoder.decodeObject(forKey: "more_available") as? Bool
         status = aDecoder.decodeObject(forKey: "status") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if items != nil{
			aCoder.encode(items, forKey: "items")
		}
		if moreAvailable != nil{
			aCoder.encode(moreAvailable, forKey: "more_available")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
