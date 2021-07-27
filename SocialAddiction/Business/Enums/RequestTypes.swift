//
//  RequestTypes.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 26.07.2021.
//

import Foundation

enum RequestTypes {
    case auth
    case media
    
    init() {
        self = .media
    }
}
