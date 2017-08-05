//
//  CustomPhotoAlbum.swift
//  Flikopi
//
//  Created by DHRUV DALWADI on 12/01/17.
//  Copyright © 2017 WebMobTech. All rights reserved.
//

import Foundation
import Photos

class CustomPhotoAlbum {
    
    static let albumName = "InstaGram"
    static let sharedInstance = CustomPhotoAlbum()
    var albumFound = Bool()
    var images : [UIImage] = [UIImage]()
    var assetCollection: PHAssetCollection!
    
    init() {
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)
        }) { success, _ in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            }
            else
            {
                
            }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _ : AnyObject = collection.firstObject {
            albumFound = true
            return collection.firstObject!
        }
        else {
            albumFound = false
        }
        
        return nil
    }
    
    
    func FetchCustomAlbumPhotos(completion: (_ albumImages: [UIImage]) -> Void) {
        
        if assetCollection == nil {
            completion([UIImage]())
            return
        }
        
        let photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil)
        let imageManager = PHCachingImageManager()
        
        self.images.removeAll()
        photoAssets.enumerateObjects(options: .concurrent) { (object, count, stop) in
            let asset = object
            let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isSynchronous = true
            imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                self.images.append(image!)
            })
        }
        completion(self.images)
    }
    
    
    
    func saveImage(image: UIImage) {
        if assetCollection == nil {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
            
            }, completionHandler: nil)
    }
    
}
