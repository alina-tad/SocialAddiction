//
//  MediaTypes.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation

enum MediaTypes: String {
    
    case image = "IMAGE"
    case video = "VIDEO"
    case carousel = "CAROUSEL_ALBUM"
    case unowned
    
    init() {
        self = .image
    }
    
    func type(typeCode: String) -> MediaTypes {
        switch typeCode {
        case "IMAGE":
            return .image
        case "VIDEO":
            return .video
        case "CAROUSEL_ALBUM":
            return .carousel
        default:
            return .unowned
        }
    }
}
