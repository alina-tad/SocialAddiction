//
//  MediaChildrenModel.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation
import ObjectMapper

class MediaChildrenModel: Mappable {
    
    var data: UserMediaModel?
    var paging: PagingMediaChildrenModel?

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        paging <- map["paging"]
    }
    
}

class PagingMediaChildrenModel: Mappable {
    
    var cursors: CursorsMediaChildrenModel?
    var previous = ""
    var next = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cursors <- map["cursors"]
        previous <- map["previous"]
        next <- map["next"]
    }
    
}

class CursorsMediaChildrenModel: Mappable {
    
    var after = ""
    var before = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        after <- map["after"]
        before <- map["before"]
    }
    
}
