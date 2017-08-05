//
//  Constants.swift
//  ViewControllerDemo
//
//  Created by SamSol on 27/06/16.
//  Copyright © 2016 SamSol. All rights reserved.
//

import Foundation
import UIKit

//  MARK: - System Oriented Constants -

//AppName
let AppName = "LargeDp"

struct SystemConstants {
    
    static let showLayoutArea = true
    static let hideLayoutArea = false
    static let showVersionNumber = 1
    
    static let IS_IPAD = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
    static let IS_DEBUG = false
}

struct General{
    static let textFieldColorAlpha : CGFloat = 0.5
}

//  MARK: - Thired Party Constants -
struct ThiredPartyKey {
    
    static let adMob : String = "ca-app-pub-7409730219034199~4604585819"
}

struct Instagram_data {
    //static let KApp_Id = "4fef19045d624e1aaab112b66ca07938"
    static let kDialogBaseURL = "https://instagram.com/"
    static let KInstagramLogin = "https://www.instagram.com/accounts/login/"
    static let kLogin = "oauth/authorize"
    static let KmainUrl = "https://instagram.com/oauth/authorize"
    static let kApp_Id = "b8ecfd43c3e34b18a29133e206f51b07"
    static let KRedirect_Uri = "webmobtech.com"
    static let Instagram_AuthUrl = "https://api.instagram.com/oauth/authorize/"
    static let Instagram_ApiurI = "https://api.instagram.com/v1/users/"
    static let Instagram_Client_id = "b8ecfd43c3e34b18a29133e206f51b07"
    //static let Instagram_Client_id = "c0a94fa83f674942ba7b41d184b8a455"
    static let Instagram_Client_Sectret = "08668d74dc584187a77dca58cb5e4e44"
    static let Instagram_redirect_Uri = "http://webmobtech.com"
    //static let Instagram_redirect_Uri = "https://polar-shelf-32169.herokuapp.com/api/v1/instagram/oauth_redirect"
    
    static let Instagram_access_token = "access_token"
    static let Instagram_Scope = "basic"
    static let Instagarm_user_access = "https://api.instagram.com/v1/users/self/?access_token"
    static let instagram_search_data = "https://api.instagram.com/v1/media/search?"
    static let instagram_userProfile = "https://api.instagram.com/v1/users/"
    
}
struct InAddvertise {
    
    static let KAddBannerKey = "ca-app-pub-7409730219034199/6081319016"
    static let KgoogleaddId = "ca-app-pub-7409730219034199~8356389417"
    static let KAddFullscreen = "ca-app-pub-7409730219034199/7558052213"
    static let kappUrl = "https://itunes.apple.com/us/app/id1241324289"
    static let kNativeadd = "ca-app-pub-7409730219034199/1511518615"
    static let kBigNativeadd = "ca-app-pub-7409730219034199/8577127010"
}

//  MARK: - Server Constants -
struct APIConstant {
    
    //  Main Domain
    static let baseURL = "https://www.instagram.com/"
    
    //  API - Sub Domain
    static let login = "accounts/login/ajax/"
    static let logout = "accounts/logout/"
    
    static let searchAll = "web/search/topsearch/?context=blended&query="
    static let searchUserAll = "web/search/topsearch/?context=blended&query=%40"
    static let searchTagAll = "web/search/topsearch/?context=blended&query="
    
    static let uploadImage = "create/upload/photo/"
    static let finalConfig = "create/configure/"
    
    static let userProfile = "/?__a=1"
    static let timeline = "?__a=1"
    
    static let placeDetails = "explore/locations/"
    
    static let tagDetails = "explore/tags/"
    static let media = "/media"
    static let profilemaxid = "?max_id="
    static let maxid = "&max_id="
    
    //  Misc
   
    static let controlRequestKey : String = "ControlRequestKey"
   
    static let username : String = "username"
    static let password : String = "password"
    
    //For Header Values
    static let accepthtml  = "text/html"
    static let acceptjson  = "application/json"
    static let ig_prValue  = "1"
    static let ig_vwValue  = "1599"
    static let xrequestedwithValue  = "XMLHttpRequest"
    static let xinstagramajaxValue = "1"
    
    //For Header Keys
    static let accept  = "*/*"
    static let referer  = "referer"
    static let xcsrftoken  = "x-csrftoken"
    static let cookie  = "cookie"
    static let ig_pr  = "ig_pr"
    static let ig_vw  = "ig_vw"
    static let ds_user_id  = "ds_user_id"
    static let s_network  = "s_network"
    static let xinstagramajax  = "x-instagram-ajax"
    static let xrequestedwith  = "x-requested-with"
    
    
    //Cookie in
    static let sessionid  = "sessionid"
    static let rur  = "rur"
    static let csrftoken  = "csrftoken"
    static let mid  = "mid"
    
    static let itunesStorelink = "https://itunes.apple.com/us/app/id1241324289"
    
    static let GoogleStorelink = "https://play.google.com/store/apps/details?id=com.wmt.android.instalargedp"
}


//  MARK: - layoutTime Constants -
struct ControlLayout {
    
    static let name : String = "controlName"
    static let borderRadius : CGFloat = 1.0
    static let zeroPadding : CGFloat = 0.0
    
    static let horizontalPadding : CGFloat = SystemConstants.IS_IPAD ? 15 : 10.0
    static let verticalPadding : CGFloat = SystemConstants.IS_IPAD ? 15 : 10.0
    
    static let secondaryHorizontalPadding : CGFloat = SystemConstants.IS_IPAD ? 20 : 15.0
    static let secondaryVerticalPadding : CGFloat = SystemConstants.IS_IPAD ? 20 : 15.0
    static let secondaryPadding : CGFloat = SystemConstants.IS_IPAD ? 10 : 5.0
    
    static let txtBorderWidth : CGFloat = 1.5
    static let txtBorderRadius : CGFloat = 2.5
    static let textFieldHeight : CGFloat = 30.0
    static let textLeftPadding : CGFloat = 10.0
}


//  MARK: - Cell Identifier Constants -
struct CellIdentifire {
    
    static let leftMenu = "leftMenu"
    static let leftMenuCell = "leftMenuCell"
    
    static let detailProfile  = "detailProfile"
    static let photoCollection  = "photoCollection"
    static let commonList = "commonList"
    static let topSearch = "topSearch"
    static let place = "place"
    static let people = "people"
    static let hashTag = "hashTag"
    static let hashTagCollection = "hashTagCollection"
    static let placeCollectction = "placeCollectction"
    static let downloadInfo = "downloadInfo"
    static let imageViewer = "ImageViewerCollectionCell"
    static let profileCollectionHeader = "profileCollectionHeader"
    
    static let profilePhoto = "profilePhoto"
    static let nativeCell = "nativeCell"

    
}

//  MARK: - Info / Error Message Constants -
struct ErrorMessage {
    
    static let noInternet = "⚠️ Internet connection is not available."
    static let noCurrentLocation = "⚠️ Unable to find current location."
    static let noCameraAvailable = "⚠️ Camera is not available in device."
    
}

struct UserDefaultKey
{
    static let KRegisterOtp             = "registerOtp"
  
    static let loginUserData            = "loginUserData"
    static let timelineData             = "timelineData"
    static let tempUserName             = "tempUserName"
    
    static let popular                  = "Popular"
    static let timeline                 = "timeline"
    
    static let isPremiumUser            = "isPremiumUser"
    
    static let LoginUserName            = "LoginUserName"
    static let userprofilemodel         = "userprofilemodel"
    
}

struct LocalNotification {
    static let logoutSuccess : String = "Logout Event"
    static let loginEvent : String = "Login Event"
    static let favouritePlaceUpdate : String = "Favourite Place Update"
    static let hideAddCollectionButton : String = "Hide Add Collection Button"
    static let showAddCollectionButton : String = "Show Add Collection Button"
    static let inapppurchase : String = "InAppPurchase"
}


struct NotificationsName {
    
    static let ProfileAPICall   = "ProfileAPICall"
    
    static let TimeLinePaggination   = "TimeLinePaggination"
    static let TrackerUserMediaPaggination   = "TrackerUserMediaPaggination"
    static let TrackerHastagPaggination   = "TrackerHastagPaggination"
    

    static let SearchUserMediaPaggination   = "SearchUserMediaPaggination"
    static let HastagPaggination   = "HastagPaggination"
    static let LoginUserMediaPaggination   = "LoginUserMediaPaggination"
    static let LocationPaggination   = "LocationPaggination"
    
    static let userBecomePremium = "userBecomePremium"
    static let DownloadCompleted   = "DownloadCompleted"
    

}


// MARK: - Device Compatibility
struct currentDevice {
    static let isIphone = (UIDevice.current.model as NSString).isEqual(to: "iPhone") ? true : false
    static let isIpad = (UIDevice.current.model as NSString).isEqual(to: "iPad") ? true : false
    static let isIPod = (UIDevice.current.model as NSString).isEqual(to: "iPod touch") ? true : false
}

