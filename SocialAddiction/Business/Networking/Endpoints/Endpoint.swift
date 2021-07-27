//
//  Endpoint.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Alamofire
import Foundation
import SwiftyJSON
import ObjectMapper

class Endpoint<Response> {
    
    let method: HTTPMethod
    let path: String
    let parameters: Parameters?
    let decode: (Data) throws -> Response?
    
    init(path: String,
         method: HTTPMethod = .get,
         parameters: Parameters? = nil,
         decode: @escaping (Data) throws -> Response?) {
        
        self.method = method
        self.path = path
        self.parameters = parameters
        self.decode = decode
    }
}

extension Endpoint {
    
    static func make<Response:BaseMappable>(_ path: String, _ method: HTTPMethod = .get, _ parameters: Parameters? = nil) -> Endpoint<Response> {
        
        return Endpoint<Response>.init(path: path,
                                       method: method,
                                       parameters: parameters,
                                       decode: { (data: Data) -> Response? in
                                        
                                        do {
                                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                                if let result = Mapper<Response>().map(JSON: json) {
                                                    return result
                                                }
                                            }
                                        } catch {
                                            debugPrint(String(data: data, encoding: String.Encoding.utf8) ?? "")
                                            debugPrint(error)
                                        }
                                        
                                        return nil
        })
    }
    
}
