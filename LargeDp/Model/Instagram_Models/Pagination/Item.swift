//
//	Item.swift
//
//	Create by VirajPatel on 8/4/2017
//	Copyright © 2017. All rights reserved.
 

import Foundation


class Item : NSObject, NSCoding{

	var altMediaUrl : Any!
	var canDeleteComments : Bool! = false
	var canViewComments : Bool! = false
	var caption : Caption!
	var code : String! = ""
	var comments : PaginationComment!
	var createdTime : String! = ""
	var id : String! = ""
	var images : Image!
	var likes : Comment!
	var link : String! = ""
	var type : String! = ""
	var user : From!
	var userHasLiked : Bool! = false
    var isSelect:Bool! = false
    var carouselMedia : [CarouselMedia]! = []
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any])
    {
        if let data = dictionary["alt_media_url"] {
            altMediaUrl = data
        }
	
        if let data = dictionary["can_delete_comments"] as? Bool {
            canDeleteComments = data
        }
        
        if let data = dictionary["can_view_comments"] as? Bool {
            canViewComments = data
        }
        
		if let captionData = dictionary["caption"] as? [String:Any]{
			caption = Caption(fromDictionary: captionData)
		}
        
        if let data = dictionary["code"] as? String {
            code = data
        }
        
		if let commentsData = dictionary["comments"] as? [String:Any]{
			comments = PaginationComment(fromDictionary: commentsData)
		}
        
        if let data = dictionary["created_time"] as? String {
            createdTime = data
        }
        
        if let data = dictionary["id"] as? String {
            id = data
        }
		
		if let imagesData = dictionary["images"] as? [String:Any]
        {
			images = Image(fromDictionary: imagesData)
		}
		
        if let likesData = dictionary["likes"] as? [String:Any]
        {
			likes = Comment(fromDictionary: likesData)
		}
		
        if let data = dictionary["link"] as? String {
            link = data
        }
        
        if let data = dictionary["type"] as? String {
            type = data
        }
        
        carouselMedia = [CarouselMedia]()
        if let carouselMediaArray = dictionary["carousel_media"] as? [[String:Any]]{
            for dic in carouselMediaArray{
                let value = CarouselMedia(fromDictionary: dic)
                carouselMedia.append(value)
            }
        }
		if let userData = dictionary["user"] as? [String:Any]{
			user = From(fromDictionary: userData)
		}
        
        if let data = dictionary["user_has_liked"] as? Bool {
            userHasLiked = data
        }
        isSelect = false
	}
    
   
	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if altMediaUrl != nil{
			dictionary["alt_media_url"] = altMediaUrl
		}
		if canDeleteComments != nil{
			dictionary["can_delete_comments"] = canDeleteComments
		}
		if canViewComments != nil{
			dictionary["can_view_comments"] = canViewComments
		}
		if caption != nil{
			dictionary["caption"] = caption.toDictionary()
		}
        if carouselMedia != nil{
            var dictionaryElements = [[String:Any]]()
            for carouselMediaElement in carouselMedia {
                dictionaryElements.append(carouselMediaElement.toDictionary())
            }
            dictionary["carousel_media"] = dictionaryElements
        }
		if code != nil{
			dictionary["code"] = code
		}
		if comments != nil{
			dictionary["comments"] = comments.toDictionary()
		}
		if createdTime != nil{
			dictionary["created_time"] = createdTime
		}
		if id != nil{
			dictionary["id"] = id
		}
		if images != nil{
			dictionary["images"] = images.toDictionary()
		}
		if likes != nil{
			dictionary["likes"] = likes.toDictionary()
		}
		if link != nil{
			dictionary["link"] = link
		}
		if type != nil{
			dictionary["type"] = type
		}
		if user != nil{
			dictionary["user"] = user.toDictionary()
		}
		if userHasLiked != nil{
			dictionary["user_has_liked"] = userHasLiked
		}
        if isSelect != nil{
            dictionary["isSelect"] = isSelect
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder) {
         altMediaUrl = aDecoder.decodeObject(forKey: "alt_media_url") as Any
         canDeleteComments = aDecoder.decodeObject(forKey: "can_delete_comments") as? Bool
         canViewComments = aDecoder.decodeObject(forKey: "can_view_comments") as? Bool
         caption = aDecoder.decodeObject(forKey: "caption") as? Caption
         code = aDecoder.decodeObject(forKey: "code") as? String
         comments = aDecoder.decodeObject(forKey: "comments") as? PaginationComment
         createdTime = aDecoder.decodeObject(forKey: "created_time") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         images = aDecoder.decodeObject(forKey: "images") as? Image
         likes = aDecoder.decodeObject(forKey: "likes") as? Comment
         link = aDecoder.decodeObject(forKey: "link") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         carouselMedia = aDecoder.decodeObject(forKey :"carousel_media") as? [CarouselMedia]
         user = aDecoder.decodeObject(forKey: "user") as? From
         userHasLiked = aDecoder.decodeObject(forKey: "user_has_liked") as? Bool
         isSelect = aDecoder.decodeObject(forKey: "isSelect") as? Bool
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if altMediaUrl != nil{
			aCoder.encode(altMediaUrl, forKey: "alt_media_url")
		}
		if canDeleteComments != nil{
			aCoder.encode(canDeleteComments, forKey: "can_delete_comments")
		}
		if canViewComments != nil{
			aCoder.encode(canViewComments, forKey: "can_view_comments")
		}
		if caption != nil{
			aCoder.encode(caption, forKey: "caption")
		}
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if comments != nil{
			aCoder.encode(comments, forKey: "comments")
		}
		if createdTime != nil{
			aCoder.encode(createdTime, forKey: "created_time")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if images != nil{
			aCoder.encode(images, forKey: "images")
		}
		if likes != nil{
			aCoder.encode(likes, forKey: "likes")
		}
		if link != nil{
			aCoder.encode(link, forKey: "link")
		}
		
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
        if carouselMedia != nil{
            aCoder.encode(carouselMedia, forKey: "carousel_media")
        }
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}
		if userHasLiked != nil{
			aCoder.encode(userHasLiked, forKey: "user_has_liked")
		}
        if isSelect != nil{
            aCoder.encode(isSelect, forKey: "isSelect")
        }
	}

}
