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
        KFManager.cleanCache()
    }
    
    //MARK: - Networking
    public func getOauthToken(code: String, _ completion: ((_ resp: AuthResponse?, _ error: AuthError?) -> Void)? = nil) {

        let parameters: [String: Any] = [
            "client_secret": Endpoints.AuthParams.clientSecret,
            "grant_type": "authorization_code",
            "redirect_uri": Endpoints.AuthParams.redirectUri,
            "client_id": Endpoints.AuthParams.clientId,
            "code": code,
        ]
        
        NetworkingClient.shared.request(EndpointsList.Auth.getToken, parameters, .auth) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
//                Popup.showSimpleNotificationView(error.string)
                completion?(nil, error as? AuthError)
            }
            
            if let result = result {
                self.token = result.accessToken
                UserManager.shared.userID = result.userId
                completion?(result, error as? AuthError)
            }
        }
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
