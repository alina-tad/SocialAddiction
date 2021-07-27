//
//  AuthResponse.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import Foundation
import ObjectMapper

class AuthResponse: Mappable {
    
    var accessToken: String?
    var userId: Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        accessToken <- map["access_token"]
        userId <- map["user_id"]
    }
}
