//
//  UserFeedManager.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation

class UserFeedManager {
    
    // MARK: - Constants
    public static let shared = UserFeedManager()
    
    
    //MARK: - Properties
    private var userFields = "id,username,media_count"
    private var limit = 19
    private var mediaFields = "caption,id,media_type,media_url,permalink,thumbnail_url,timestamp,username"

    
    // MARK: - Init
    private init() {
        
    }
    
    
    // MARK: - Networking
    func fetchUser(_ completion: ((_ response: UserModel, _ error: NetworkingError?) -> Void)? = nil) {
        
        let parameters = [
            "fields": userFields,
            "access_token": AuthNetworking.shared.token ?? "",
        ] as [String : Any]
        
        NetworkingClient.request(endpoint: EndpointsList.User.userNode, parameters: parameters) { (resp, error) in
            completion?(resp ?? UserModel(), error)
        }
    }
    
    
    
    
    func fetchUserMedia(_ completion: ((_ response: ResultMediaModel, _ error: NetworkingError?) -> Void)? = nil) {

        let parameters = [
            "limit": limit,
            "fields": mediaFields,
            "access_token": AuthNetworking.shared.token ?? "",
        ] as [String : Any]

        NetworkingClient.request(endpoint: EndpointsList.Media.meMedia, parameters: parameters) { (resp, error) in
            completion?(resp ?? ResultMediaModel(), error)
        }
    }
    
    func fetchUserMediaNextPortion(type: PagingTypes, code: String, _ completion: ((_ response: ResultMediaModel, _ error: NetworkingError?) -> Void)? = nil) {

        let parameters = [
            "\(type.string)": code,
            "fields": mediaFields,
            "access_token": AuthNetworking.shared.token ?? "",
            "limit": limit
        ] as [String : Any]

        let endpoint: Endpoint<ResultMediaModel> = Endpoint<ResultMediaModel>.make("/v11.0/\(UserManager.shared.userID ?? 0)/media", .get)

        NetworkingClient.request(endpoint: endpoint, parameters: parameters) { (resp, error) in
            completion?(resp ?? ResultMediaModel(), error)
        }
    }
    
    func fetchDetailMedia(id: String, _ completion: ((_ response: UserMediaModel, _ error: NetworkingError?) -> Void)? = nil) {
        
        let parameters = [
            "fields": mediaFields,
            "access_token": AuthNetworking.shared.token ?? "",
        ] as [String : Any]
        
        let endpoint: Endpoint<UserMediaModel> = Endpoint<UserMediaModel>.make("/\(id)", .get)
        
        NetworkingClient.request(endpoint: endpoint, parameters: parameters) { (resp, error) in
            completion?(resp ?? UserMediaModel(), error)
        }
    }
    
    //For carousel
    func fetchMediaChildren(id: Int, fields: String, _ completion: ((_ response: MediaChildrenModel, _ error: NetworkingError?) -> Void)? = nil) {
        
        let parameters = [
            "fields": mediaFields,
            "access_token": AuthNetworking.shared.token ?? "",
        ] as [String : Any]
        
        let endpoint: Endpoint<MediaChildrenModel> = Endpoint<MediaChildrenModel>.make("\(id)/children", .get)
        
        NetworkingClient.request(endpoint: endpoint, parameters: parameters) { (resp, error) in
            completion?(resp ?? MediaChildrenModel(), error)
        }
    }
    
}
