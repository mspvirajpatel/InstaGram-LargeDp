//
//  DownloadManager.swift
//  DownloaderDemo
//
//  Created by WebMob on 08/04/17.
//  Copyright © 2017 WebMobTech. All rights reserved.
//

import UIKit
import Foundation
import Photos
import SwiftEventBus

@objc public protocol DownloadManagerDelegate
{
    /**A delegate method called each time whenever any download task's progress is updated
     */
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int)
    
    /**A delegate method called when interrupted tasks are repopulated
     */
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModel: [MZDownloadModel])
    
    /**A delegate method called each time whenever new download task is start downloading
     */
    func downloadRequestStarted(downloadModel : MZDownloadModel , index : Int)
    
    /**A delegate method called each time whenever running download task is paused. If task is already paused the action will be ignored
     */
    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is resumed. If task is already downloading the action will be ignored
     */
    func downloadRequestDidRetry(_ downloadModel: MZDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is cancelled by the user
     */
    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is finished successfully
     */
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int)
    
    /**A delegate method called each time whenever any download task is failed due to any reason
     */
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int)
    
    /**A delegate method called each time whenever specified destination does not exists. It will be called on the session queue. It provides the opportunity to handle error appropriately
     */
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL)
}

class DownloadManager: NSObject
{
    public static let shared : DownloadManager = DownloadManager()
    weak var delegate : DownloadManagerDelegate?
    private var downloadPath : String = MZUtility.baseFilePath + "/InstagramDownload"
    
    lazy var mzDownloader : MZDownloadManager = { [unowned self] in
        
        let sessionIdentifer: String = "com.iosDevelopment.MZDownloadManager.BackgroundSession"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
        }()
    
    private override init() {
        super.init()
        self.createDownloadFolder()
    }
    
    private func createDownloadFolder(){
        
        do{
            if !FileManager.default.fileExists(atPath: downloadPath){
                try FileManager.default.createDirectory(atPath: downloadPath, withIntermediateDirectories: true, attributes: nil)
            }
        }
        catch let error as NSError{
            print("Error :- \(error.localizedDescription)")
        }
    }
    
    internal func saveImageInLibrary(imageURL : String){
        do{
            let imagePath : String = (downloadPath as NSString).appendingPathComponent(imageURL)
            
            if let image = try UIImage(data: Data(contentsOf: URL(fileURLWithPath: imagePath))){
                
                let status = PHPhotoLibrary.authorizationStatus()
                switch status {
                case .authorized:
                    
                    CustomPhotoAlbum.sharedInstance.saveImage(image:image)
                    break
                    
                case .denied, .restricted :
                    
                    break
                case .notDetermined:
                    // ask for permissions
                    
                    
                    PHPhotoLibrary.requestAuthorization() {  [weak self] status in
                        if self == nil
                        {
                            return
                        }
                        switch status {
                        case .authorized:
                            CustomPhotoAlbum.sharedInstance.saveImage(image:image)
                            
                            break
                        // as above
                        case .denied, .restricted:
                            
                            break
                            
                        default:
                            break
                            
                        }
                        
                    }
                }
                // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        catch let error as NSError{
            print("error :- \(error.localizedDescription)")
        }
        //       let imagePath : String = (downloadPath as NSString).appendingPathComponent(imageURL)
        
        //        do{
        //            if FileManager.default.fileExists(atPath: imagePath){
        //
        
        //               try FileManager.default.removeItem(at: URL(fileURLWithPath: imagePath))
        //           }
        //       }
        //       catch let error as NSError{
        //           print("error :- \(error.localizedDescription)")
        //       }
    }
    
    public func downloadFiles(arrURL : NSMutableArray,isFavorite : Int){
        
        /*
         Save in Database Start
         */
        
        var modelType : ImageEditorViewType = .unknown
        var strJSON : String = ""
        var modelID : String = ""
        
        for url in arrURL {
            modelType = .unknown
            strJSON = ""
            modelID = ""
            if let follower : FollowersEdge = url as? FollowersEdge {
                
                if let dict : NSDictionary = follower.toDictionary() as NSDictionary! {
                    modelType = .follow
                    strJSON = dict.JSONString() as String
                    modelID = follower.node.id
                }
            }
            else if let searchUser : SearchUser = url as? SearchUser
            {
                if let dict : NSDictionary = searchUser.toDictionary() as NSDictionary! {
                    modelType = .searchUser
                    strJSON = dict.JSONString() as String
                    modelID = searchUser.user.pk
                }
            }
            //Save into Database from hear
            do
            {
                let timeStamp : Int = Int(Date().timeIntervalSince1970)
                try DatabaseManager.sharedInstance.insertModel(data: strJSON, type: modelType.rawValue,modelId: modelID,timeStamp: String(timeStamp),isFavorite:isFavorite)
            }
            catch let error as NSError
            {
                print(error.description)
            }
        }
        
        SwiftEventBus.post(NotificationsName.DownloadCompleted)
        
        /*
         Save in Database End
         */
        
//        for url in arrURL {
//            if let timline = url as? TimeLineNode
//            {
//                if timline.owner.username != nil {
//                    self.downloadFile(fileURL: timline.displayUrl , username: timline.owner.username)
//                }
//                else{
//                    self.downloadFile(fileURL: timline.displayUrl , username: "")
//                }
//                
//            }
//            else if let profileNode = url as? ProfileNode {
//                if profileNode.owner.username != nil {
//                    self.downloadFile(fileURL: profileNode.displaySrc , username: profileNode.owner.username)
//                }
//                else {
//                    self.downloadFile(fileURL: profileNode.displaySrc , username: "")
//                }
//                
//            }
//            else if let locationNode = url as? LocationNode {
//                if locationNode.owner.username != nil
//                {
//                    self.downloadFile(fileURL: locationNode.displaySrc , username: locationNode.owner.username)
//                }
//                else{
//                    self.downloadFile(fileURL: locationNode.displaySrc , username: "")
//                }
//            }
//            else if let item = url as? Item {
//                if item.user.username != nil {
//                    if item.images.standardResolution.url != nil {
//                        self.downloadFile(fileURL: item.images.standardResolution.url , username: item.user.username)
//                    }
//                    else{
//                        self.downloadFile(fileURL: item.images.lowResolution.url , username: item.user.username)
//                    }
//                    
//                }
//                else {
//                    if item.images.standardResolution.url != nil {
//                        self.downloadFile(fileURL: item.images.standardResolution.url , username: "")
//                    }
//                    else{
//                        self.downloadFile(fileURL: item.images.lowResolution.url , username: "")
//                    }
//                    
//                }
//            }
//            else if let locationNode = url as? UserProfileModel
//            {
//                if locationNode.user.username != nil
//                {
//                    if locationNode.user.profilePicUrlHd != nil
//                    {
//                        self.downloadFile(fileURL: locationNode.user.profilePicUrlHd , username: locationNode.user.username)
//                    }
//                    else
//                    {
//                        self.downloadFile(fileURL: locationNode.user.profilePicUrl , username: locationNode.user.username)
//                    }
//                    
//                }
//                else{
//                    if locationNode.user.profilePicUrlHd != nil
//                    {
//                        self.downloadFile(fileURL: locationNode.user.profilePicUrlHd , username: "")
//                    }
//                    else
//                    {
//                        self.downloadFile(fileURL: locationNode.user.profilePicUrl , username: "")
//                    }
//                }
//            }
//            else if let follower = url as? FollowersEdge
//            {
//                if follower.node.username != nil
//                {
//                    if follower.node.profilePicUrl != nil
//                    {
//                        self.downloadFile(fileURL: follower.node.profilePicUrl , username: follower.node.username)
//                    }
//                }
//                else{
//                    if follower.node.profilePicUrl != nil
//                    {
//                        self.downloadFile(fileURL: follower.node.profilePicUrl , username: "")
//                    }
//                }
//            }
//        else if let searchUser = url as? SearchUser
//        {
//            if  searchUser.user.username != nil
//            {
//                if searchUser.user.profilePicUrl != nil
//                {
//                    self.downloadFile(fileURL: searchUser.user.profilePicUrl , username: searchUser.user.username)
//                }
//            }
//            else{
//                if searchUser.user.profilePicUrl != nil
//                {
//                    self.downloadFile(fileURL: searchUser.user.profilePicUrl , username: "")
//                }
//            }
//        }
//            else if let locationNode = url as? String
//            {
//                self.downloadFile(fileURL: locationNode , username: "")
//            }
//            
//        }
    }
    
    public func downloadFile(fileURL : String , username : String){
        
        let url : NSString = fileURL as NSString
        let fileName : String = url.lastPathComponent
        //        fileName = MZUtility.getUniqueFileNameWithPath(downloadPath as NSString).appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: (downloadPath as NSString).appendingPathComponent(fileName)){
            do
            {
                try FileManager.default.removeItem(atPath: (downloadPath as NSString).appendingPathComponent(fileName))
            }
            catch let error as NSError
            {
                print("Error :- \(error.localizedDescription)")
            }
        }
        
        mzDownloader.addDownloadTask(fileName, fileURL: fileURL.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, destinationPath: downloadPath as String, username: username)
    }
    
}

// MARK : MZDownloadManager Delegate Method
extension DownloadManager : MZDownloadManagerDelegate{
    
    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestStarted(downloadModel: downloadModel, index: index)
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
        if delegate != nil{
            delegate!.downloadRequestDidPopulatedInterruptedTasks(downloadModels)
        }
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestDidUpdateProgress(downloadModel, index: index)
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        if delegate != nil{
            delegate!.downloadRequestDidPaused(downloadModel, index: index)
        }
    }
    
    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        if delegate != nil{
            delegate!.downloadRequestDidResumed(downloadModel, index: index)
        }
    }
    
    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestCanceled(downloadModel, index: index)
        }
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate!.downloadRequestFinished(downloadModel, index: index)
        }
        
        self.saveImageInLibrary(imageURL: downloadModel.fileName)
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DownloadUpdates"), object: nil)
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        
        if delegate != nil{
            delegate?.downloadRequestDidFailedWithError(error, downloadModel: downloadModel, index: index)
        }
        debugPrint("Error while downloading file: \(downloadModel.fileName)  Error: \(error)")
    }
    
    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        
        if delegate != nil{
            delegate?.downloadRequestDestinationDoestNotExists(downloadModel,index: index, location: location)
        }
        else
        {
            let myDownloadPath = MZUtility.baseFilePath + "/Default folder"
            if !FileManager.default.fileExists(atPath: myDownloadPath) {
                try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
            }
            let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
            let path =  myDownloadPath + "/" + (fileName as String)
            try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
            debugPrint("Default folder path: \(myDownloadPath)")
        }
    }
}
