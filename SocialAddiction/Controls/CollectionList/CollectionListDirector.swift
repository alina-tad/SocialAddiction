//
//  CollectionListDirector.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit

class CollectionListDirector: NSObject, UICollectionViewDataSource {
    
    // MARK: - Handlers
    public var actionHandler: ((_ index: Int) -> Void)? = nil

    
    // MARK: - Properties
    
    var cellBuilder = CollectionListCellBuilder()
    var data: [CollectionListViewModel] = []
    var collectionView: UICollectionView!
    
    
    // MARK: - Navigations
    func prepare(_ data: [CollectionListViewModel], _ collectionView: UICollectionView) {
        self.data = data
        self.collectionView = collectionView

        
        self.cellBuilder.prepare(collectionView)
        
        self.cellBuilder.actionHandler = { index in
            self.actionHandler?(index)
        }

    }
    
    func index(_ indexPath: IndexPath) -> Int {
        return indexPath.row
    }
    
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellBuilder.createCell(data[index(indexPath)], indexPath)
    }
}
