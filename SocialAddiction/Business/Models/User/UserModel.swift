//
//  UserModel.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import Foundation
import ObjectMapper

class UserModel: Mappable {
    
    var id = ""
    var username = ""
    var mediaCount = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        username <- map["username"]
        mediaCount <- map["media_count"]
    }
    
}
