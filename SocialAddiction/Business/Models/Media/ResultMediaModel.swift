//
//  ResultModel.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation
import ObjectMapper

class ResultMediaModel: Mappable {
    
    var data: [UserMediaModel]? = nil
    var paging: PagingMediaChildrenModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        paging <- map["paging"]
    }
}
