//
//  FeedCollectionCellModel.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import Foundation
import ObjectMapper

class FeedCollectionCellModel: Mappable {
    
    // MARK: - Properties
    var photoUrlString: String?
    var mediaType: MediaTypes?
    
    
    // MARK: - Init
    init(photoUrlString: String,_ mediaType: MediaTypes? = nil) {
        self.photoUrlString = photoUrlString
        self.mediaType = mediaType
    }
    
    required convenience init?(map: Map) {
        self.init(photoUrlString: "")
    }
    
    
    // MARK: - Mapping
    func mapping(map: Map) {
        photoUrlString <- map["photoUrlString"]
        mediaType <- map["mediaType"]
    }
    
}
