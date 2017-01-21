//
//  CustomVideoModel.swift
//  kairat
//
//  Created by beka on 1/12/17.
//  Copyright © 2017 Beka. All rights reserved.
//

import UIKit
import Kingfisher
import INSPhotoGallery

class CustomVideoModel: NSObject, INSPhotoViewable {
    var image: UIImage?
    var thumbnailImage: UIImage?
    
    var imageURL: URL?
    var thumbnailImageURL: URL?
    var videoURL:String?
    
    var attributedTitle: NSAttributedString? {
        return NSAttributedString(string: "Example caption text", attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    init(image: UIImage?, thumbnailImage: UIImage?) {
        self.image = image
        self.thumbnailImage = thumbnailImage
    }
    
    init(imageURL: URL?, thumbnailImageURL: URL?,videoURL:String?) {
        self.imageURL = imageURL
        self.thumbnailImageURL = thumbnailImageURL
        self.videoURL=videoURL
    }
    
    init (imageURL: URL?, thumbnailImage: UIImage) {
        self.imageURL = imageURL
        self.thumbnailImage = thumbnailImage
    }
    
    func loadImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        if let url = imageURL {
            
            KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                completion(image, error)
            })
        } else {
            completion(nil, NSError(domain: "PhotoDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load image"]))
        }
    }
    func loadThumbnailImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        if let thumbnailImage = thumbnailImage {
            completion(thumbnailImage, nil)
            return
        }
        if let url = thumbnailImageURL {
            KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: url), options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, url) in
                completion(image, error)
            })
        } else {
            completion(nil, NSError(domain: "PhotoDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load image"]))
        }
    }
}

