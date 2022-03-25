//
//  NetworkingError.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation
import ObjectMapper

enum NetworkingError: Error {
    
    case networkingError(String)
    case noInternet
    case invalidData
    case unowned
    case validationTokenError

    var string: String {
        switch self {
        case .networkingError(let message): return message
        case .noInternet: return "Server connection error. Check your internet connection"
        case .invalidData: return "Invalid data error"
        default:
            return "Something went wrong"
        }
    }
}
