//
//  UserManager.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import Foundation
import ObjectMapper

class UserManager {
    
    //MARK: - Constants
    public static let shared = UserManager()
    
    
    //MARK: - Properies
    var userID: Int? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.UserKeys.userID)
        }
        get {
            return UserDefaults.standard.integer(forKey: Constants.UserKeys.userID)
        }
    }
    
    private init () {
    }
    
}
