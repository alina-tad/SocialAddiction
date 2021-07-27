//
//  EndpointsList.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation

struct EndpointsList {
    
    struct User {
        static let userNode: Endpoint<UserModel>          = Endpoint<UserModel>.make(Endpoints.User.userNode, .get)
    }
    
    struct Media {
        static let meMedia: Endpoint<ResultMediaModel>          = Endpoint<ResultMediaModel>.make(Endpoints.Media.meMedia, .get)
    }
    
}
