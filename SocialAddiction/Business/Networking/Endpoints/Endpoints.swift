//
//  Endpoints.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import Foundation

struct Endpoints {
    
    struct AuthParams {
        static let clientId     = 288234539727170
        static let redirectUri  = "https://www.google.com/"
        static let scope        = "user_profile,user_media"
        static let clientSecret = "f8f65286237b18b78527121c44cad7fe"
    }
    
    static let url              = Bundle.main.object(forInfoDictionaryKey: "MainHostURL") as! String
    static let graphUrl         = Bundle.main.object(forInfoDictionaryKey: "GraphHostURL") as! String
    
    struct User {
        static let userNode     = "/me"
    }
    
    struct Media {
        static let meMedia      = "/me/media"
    }
    
    struct Auth {
        static let getToken     = "/oauth/access_token"
        static let authUrlString                = "https://api.instagram.com/oauth/authorize?client_id=\(AuthParams.clientId)&redirect_uri=\(AuthParams.redirectUri)&scope=\(AuthParams.scope)&response_type=code"
    }
    
}
