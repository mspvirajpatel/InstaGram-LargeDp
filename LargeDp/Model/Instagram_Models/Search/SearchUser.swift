//
//	User.swift
//
//	Create by MacMini-2 on 7/4/2017
//	Copyright © 2017. All rights reserved.


import Foundation


class SearchUser : NSObject, NSCoding{

	var byline : String! = ""
	var followerCount : Int! = 0
	var fullName : String! = ""
	var hasAnonymousProfilePicture : Bool! = false
	var isPrivate : Bool! = false
	var isVerified : Bool! = false
	var mutualFollowersCount : Int! = 0
	var pk : String! = ""
	var profilePicUrl : String! = ""
	var username : String! = ""
	var position : Int! = 0
	var user : SearchUser!
    var profilePicUrl320 : String! = ""
    var profilePicUrlHD : String! = ""

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any])
    {
        if let data = dictionary["byline"] as? String {
            byline = data
        }
        
        if let data = dictionary["follower_count"] as? Int {
            followerCount = data
        }
        
        if let data = dictionary["full_name"] as? String {
            fullName = data
        }
        
        if let data = dictionary["has_anonymous_profile_picture"] as? Bool {
            hasAnonymousProfilePicture = data
        }
        
        if let data = dictionary["is_private"] as? Bool {
            isPrivate = data
        }
		
        if let data = dictionary["is_verified"] as? Bool {
            isVerified = data
        }
		
        if let data = dictionary["mutual_followers_count"] as? Int {
            mutualFollowersCount = data
        }
        
        if let data = dictionary["pk"] as? String {
            pk = data
        }
        
        if let data = dictionary["profile_pic_url"] as? String {
            profilePicUrl = data
            let newString = profilePicUrl.replacingOccurrences(of: "/s150x150", with: "/s320x320", options: .literal, range: nil)
            profilePicUrl320 = newString
            
            let newStringHD = profilePicUrl.replacingOccurrences(of: "/s150x150", with: "", options: .literal, range: nil)
            profilePicUrlHD = newStringHD
        }
        
        if let data = dictionary["username"] as? String {
            username = data
        }
		
        if let data = dictionary["position"] as? Int {
            position = data
        }
		
		if let userData = dictionary["user"] as? [String:Any]
        {
			user = SearchUser(fromDictionary: userData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if byline != nil{
			dictionary["byline"] = byline
		}
		if followerCount != nil{
			dictionary["follower_count"] = followerCount
		}
		if fullName != nil{
			dictionary["full_name"] = fullName
		}
		if hasAnonymousProfilePicture != nil{
			dictionary["has_anonymous_profile_picture"] = hasAnonymousProfilePicture
		}
		if isPrivate != nil{
			dictionary["is_private"] = isPrivate
		}
		if isVerified != nil{
			dictionary["is_verified"] = isVerified
		}
		if mutualFollowersCount != nil{
			dictionary["mutual_followers_count"] = mutualFollowersCount
		}
		if pk != nil{
			dictionary["pk"] = pk
		}
		if profilePicUrl != nil{
			dictionary["profile_pic_url"] = profilePicUrl
		}
		if username != nil{
			dictionary["username"] = username
		}
		if position != nil{
			dictionary["position"] = position
		}
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
         byline = aDecoder.decodeObject(forKey: "byline") as? String
         followerCount = aDecoder.decodeObject(forKey: "follower_count") as? Int
         fullName = aDecoder.decodeObject(forKey: "full_name") as? String
         hasAnonymousProfilePicture = aDecoder.decodeObject(forKey: "has_anonymous_profile_picture") as? Bool
         isPrivate = aDecoder.decodeObject(forKey: "is_private") as? Bool
         isVerified = aDecoder.decodeObject(forKey: "is_verified") as? Bool
         mutualFollowersCount = aDecoder.decodeObject(forKey: "mutual_followers_count") as? Int
         pk = aDecoder.decodeObject(forKey: "pk") as? String
         profilePicUrl = aDecoder.decodeObject(forKey: "profile_pic_url") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String
         position = aDecoder.decodeObject(forKey: "position") as? Int
         user = aDecoder.decodeObject(forKey: "user") as? SearchUser

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if byline != nil{
			aCoder.encode(byline, forKey: "byline")
		}
		if followerCount != nil{
			aCoder.encode(followerCount, forKey: "follower_count")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "full_name")
		}
		if hasAnonymousProfilePicture != nil{
			aCoder.encode(hasAnonymousProfilePicture, forKey: "has_anonymous_profile_picture")
		}
		if isPrivate != nil{
			aCoder.encode(isPrivate, forKey: "is_private")
		}
		if isVerified != nil{
			aCoder.encode(isVerified, forKey: "is_verified")
		}
		if mutualFollowersCount != nil{
			aCoder.encode(mutualFollowersCount, forKey: "mutual_followers_count")
		}
		if pk != nil{
			aCoder.encode(pk, forKey: "pk")
		}
		if profilePicUrl != nil{
			aCoder.encode(profilePicUrl, forKey: "profile_pic_url")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}
		if position != nil{
			aCoder.encode(position, forKey: "position")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}
