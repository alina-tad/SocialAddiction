//
//  CollectionListCellBuilder.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit

class CollectionListCellBuilder {
    
    // MARK: - Handlers
    public var actionHandler: ((_ index: Int) -> Void)? = nil
    
    
    // MARK: - Properties
    var collectionView: UICollectionView!
    
    
    // MARK: - Navigations
    func prepare(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        configureCells()
    }
    
    
    // MARK: - Configure
    func configureCells() {
        self.collectionView.register(FeedCollectionViewCell.nib, forCellWithReuseIdentifier: "FeedCollectionViewCell")
    }
    
    
    // MARK: - Builder
    func createCell(_ item: CollectionListViewModel, _ indexPath: IndexPath) -> UICollectionViewCell {
        
        if let model = item.model as? FeedCollectionCellModel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as! FeedCollectionViewCell
            cell.configureFeedCell(model.photoUrlString ?? "", model.mediaType ?? .image)
            return cell
        }

        return UICollectionViewCell()
    }
}
