//
//  Result.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation
import ObjectMapper

class Result<T: Mappable>: Mappable {
    
    var data: [T]? = nil
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}
