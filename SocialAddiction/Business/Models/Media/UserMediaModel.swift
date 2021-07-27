//
//  UserMediaModel.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation
import ObjectMapper

class UserMediaModel: Mappable {
    
    var id = ""
    var caption = ""
    var mediaType = ""
    var mediaUrl = ""
    var permalink = ""
    var thumbnailUrl = ""
    var timestamp = ""
    var username = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        caption <- map["caption"]
        mediaType <- map["media_type"]
        mediaUrl <- map["media_url"]
        permalink <- map["permalink"]
        thumbnailUrl <- map["thumbnail_url"]
        timestamp <- map["timestamp"]
        username <- map["username"]
    }
    
}

