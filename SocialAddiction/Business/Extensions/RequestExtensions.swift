//
//  Request+Extensions.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation
import Alamofire

extension Request {
    
    public func outLogger() -> Self {

        let urlString = self.request?.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = self.request?.httpMethod ?? ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(method)\n"
        requestLog += "\(urlString)\n"
        requestLog += "\(path)\n"
        requestLog += "\(query)"
        requestLog += "Host: \(host)\n"
        for (key,value) in self.request?.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = self.request?.httpBody{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";

        print(requestLog)
        return self
    }
    
    class func inLogger(data: Data?, response: HTTPURLResponse?, error: Error?) {

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let statusCode =  response?.statusCode{
            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "<------------------------\n";
        print(responseLog)
    }
}
