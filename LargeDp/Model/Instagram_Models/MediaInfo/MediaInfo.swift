//
//	MediaInfo.swift
//
//	Create by MacMini-2 on 7/4/2017
//	Copyright © 2017. All rights reserved.


import Foundation


class MediaInfo : NSObject, NSCoding{

	var media : InfoMedia!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let mediaData = dictionary["media"] as? [String:Any]{
			media = InfoMedia(fromDictionary: mediaData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if media != nil{
			dictionary["media"] = media.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         media = aDecoder.decodeObject(forKey: "media") as? InfoMedia

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if media != nil{
			aCoder.encode(media, forKey: "media")
		}

	}

}
