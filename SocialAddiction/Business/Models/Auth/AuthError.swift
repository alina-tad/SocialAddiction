//
//  AuthError.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import Foundation
import ObjectMapper

class AuthError: Mappable {
    
    var errorType: String?
    var code: Int?
    var errorMessage: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        errorType <- map["error_type"]
        code <- map["code"]
        errorMessage <- map["error_message"]
    }
}
