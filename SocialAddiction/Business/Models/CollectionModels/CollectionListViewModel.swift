//
//  CollectionListViewModel.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//


import Foundation
import ObjectMapper

class CollectionListViewModel {
        
    // MARK: - Properties
    var model: Mappable?
    
    
    // MARK: - Init
    init(_ model: FeedCollectionCellModel) {
        self.model = model
    }
}
