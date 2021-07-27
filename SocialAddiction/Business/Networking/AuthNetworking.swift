//
//  AuthNetworking.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import Foundation
import KeychainAccess
import ObjectMapper

class AuthNetworking: NSObject {
    
    //MARK: - Constants
    static let shared = AuthNetworking()
    
    
    // MARK: - Private
    private let keychain = Keychain(service: "SocialAddiction")
    
    
    //MARK: - Properties
    public var authCode: String? {
        get {
            if let code = try? keychain.get(Constants.SecurityKeys.authCodeKey) {
                return code
            }
            return nil
        }
        set {
            if newValue == nil {
                do {
                    try keychain.remove(Constants.SecurityKeys.authCodeKey)
                } catch let error {
                    print("authCode_error: \(error)")
                }
            } else {
                keychain[Constants.SecurityKeys.authCodeKey] = newValue
            }
        }
    }
    
    public var token: String? {
        get {
            if let token = try? keychain.get(Constants.SecurityKeys.token) {
                return token
            }
            return nil
        }
        set {
            if newValue == nil {
                do {
                    try keychain.remove(Constants.SecurityKeys.token)
                } catch let error {
                    print("token_error: \(error)")
                }
            } else {
                keychain[Constants.SecurityKeys.token] = newValue
            }
        }
    }
    
    
    // MARK: - Enums
    private enum Endpoint {
        
        case auth
        case accessToken
        
        var url: URL? {
            switch self {
            case .auth:
                return URL.init(string: Endpoint.mainHost + "/oauth/authorize")
            case .accessToken:
                return URL.init(string: Endpoint.mainHost + "/oauth/access_token")
            }
        }
        
        static let mainHost = Endpoints.url
    }
    
    
    func removeUserData() {
        token = nil
        authCode = nil
        UserManager.shared.userID = nil
        let cookieJar : HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! as [HTTPCookie]{
            if cookie.domain == ".instagram.com" {
                cookieJar.deleteCookie(cookie)
            }
        }
    }
    
    
    //MARK: - Networking
    
    public func getOauthToken(code: String, _ completion: ((_ resp: AuthResponse?, _ error: AuthError?) -> Void)? = nil) {
        
        guard let url = Endpoint.accessToken.url else {
                completion?(nil, nil)
                return
        }

        let clientId = Endpoints.AuthParams.clientId
        let clientSecret = Endpoints.AuthParams.clientSecret
        let grantType = "authorization_code"
        let redirectUri = Endpoints.AuthParams.redirectUri

        let params = "client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=\(grantType)&redirect_uri=\(redirectUri)&code=\(code)".data(using: String.Encoding.ascii, allowLossyConversion: true)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = 10
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = params

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)

        let task = session.dataTask(with: urlRequest) { (data, response, error) in

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let resp = Mapper<AuthResponse>().map(JSON: json) {

                        self.token = resp.accessToken
                        UserManager.shared.userID = resp.userId
                        completion?(resp, error as? AuthError)
                    }

                } catch let error {
                    print(error.localizedDescription)
                    completion?(nil, error as? AuthError)
                }
            } else if let error = error {
                print(error.localizedDescription)
                completion?(nil, error as? AuthError)
            }
        }

        task.resume()
    }
}

extension AuthNetworking: URLSessionDelegate {

    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential,
                          URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
