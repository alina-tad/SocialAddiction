//
//  PagingTypes.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 26.07.2021.
//

import Foundation

enum PagingTypes{
    
    case after
    case before
    
    var string: String {
        switch self {
        case .after:
            return "after"
        case .before:
            return "before"
        }
    }
}
