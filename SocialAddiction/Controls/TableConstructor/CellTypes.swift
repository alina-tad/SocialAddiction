//
//  CellTypes.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 26.07.2021.
//

import Foundation
import UIKit

enum CellTypes {
    case imageCell(model: UserMediaModel, postType: MediaTypes, tag: Int)
    case videoCell(model: UserMediaModel, postType: MediaTypes, tag: Int)
    case carouselCell(model: UserMediaModel, postType: MediaTypes, tag: Int)
}
