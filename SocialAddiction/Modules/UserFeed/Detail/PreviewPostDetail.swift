//
//  PreviewPostDetail.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 26.07.2021.
//

import Foundation

class PreviewPostDetail: TableConstructorProtocol {
    
    var media: UserMediaModel?
    var mediaTypes = MediaTypes()
    
    
    init(_ media: UserMediaModel) {
        self.media = media
    }

    
    var cellTypes: [CellTypes] {
        get {
            var imageCell: [CellTypes] = []
            
            switch mediaTypes.type(typeCode: media?.mediaType ?? "") {
            case .image:
                imageCell = [.imageCell(model: media ?? UserMediaModel(), postType: MediaTypes().type(typeCode: media?.mediaType ?? ""), tag: 1)]
            case .carousel:
                imageCell = [.imageCell(model: media ?? UserMediaModel(), postType: MediaTypes().type(typeCode: media?.mediaType ?? ""), tag: 1)] // There must be a custom cell for Carousel type content etc
            default:
                imageCell = []
            }
            
            return imageCell
        }
    }
    
}
