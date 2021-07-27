//
//  NetworkingClient.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Alamofire
import Foundation
import SwiftyJSON
import ObjectMapper

class NetworkingClient: NSObject {
    
    //MARK: - Constants
    static let shared = NetworkingClient()
    
    
    //MARK: - Properties
    public var manager = Alamofire.SessionManager()
    private let queue = DispatchQueue(label: "networking.client.query")
    private var mediaURL = URL.init(string: Endpoints.graphUrl)
    private var authURL = URL.init(string: Endpoints.url)

    
    // MARK: - Networking
    func request<Response> (
        _ endpoint: Endpoint<Response>,
        _ parameters: Parameters? = nil,
        _ requestType: RequestTypes,
        _ completion: ((_ result: Response?, _ error: NetworkingError?) -> Void)? = nil) {
        
        let url: URL?
        switch requestType {
        case .auth:
            url = authURL?.appendingPathComponent(endpoint.path)
        case .media:
            url = mediaURL?.appendingPathComponent(endpoint.path)
        }
        
        guard let url = url else {
            completion?(nil, .unowned)
            return
        }
        
        var params: Parameters = [:]
        var encoding: ParameterEncoding = JSONEncoding.default
        
        if endpoint.method == .post || endpoint.method == .put {
            
            if let keys = parameters?.keys {
                for key in keys {
                    params[key] = parameters?[key]
                }
            }
            
            encoding = JSONEncoding.default
            
        } else if endpoint.method == .get || endpoint.method == .delete {
            
            if let keys = parameters?.keys {
                for key in keys {
                    params[key] = parameters?[key]
                }
            }
            
            encoding = URLEncoding.default
        }
        
        self.manager.request(
            url,
            method: endpoint.method,
            parameters: (params.count == 0) ? nil : params,
            encoding: encoding)
            .validate()
            .outLogger()
            .responseData(queue: self.queue) { response in
                
                Request.inLogger(data: response.data, response: response.response, error: response.error)
                
                switch response.result {
                case .success:
                    
                    if let result = response.flatMap(endpoint.decode).value {
                        DispatchQueue.main.async {
                            completion?(result, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion?(nil, .invalidData)
                        }
                    }
                    break
                case .failure(_):
                    let error = NetworkingClient.parseError(response.data, response.error as? URLError)
                    DispatchQueue.main.async {
                        completion?(nil, error)
                        self.cancelAll()
                    }
                    break
                }
        }
    }
    
    
    //
    func cancelAll() {
        self.manager.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
}


//MARK: - Class func
extension NetworkingClient {

    class func request<Response>(
        endpoint: Endpoint<Response>,
        parameters: Parameters? = nil,
        _ requestType: RequestTypes = .media,
        _ completion: ((_ result: Response?, _ error: NetworkingError?) -> Void)? = nil) {
        
        NetworkingClient.shared.request(endpoint, parameters, requestType, completion)
    }
    
    class func parseError(_ data: Data?, _ urlerror: URLError? = nil) -> NetworkingError {
        if let data = data {
            do {
                let json = try JSON(data: data)
                if let errorArray = json["error"].array {
                    for element in errorArray {
                        let message = element["message"].string
                        return .networkingError(message ?? "Something went wrong")
                    }
                }
            } catch {
                if let urlerror = urlerror {
                    if urlerror.code  == URLError.Code.notConnectedToInternet {
                        return .noInternet
                    }
                }
            }
        }
        
        return .networkingError("Something went wrong")
    }
    
}


//MARK: - URLSessionDelegate
extension NetworkingClient: URLSessionDelegate {
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential,
                          URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
