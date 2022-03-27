//
//  FeedCollectionViewCell.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit
import Kingfisher

class FeedCollectionViewCell: UICollectionViewCell {
    
    static var nib: UINib {
           return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var carouselImageView: UIImageView!
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        carouselImageView.image = UIImage(named: "carousel")
        carouselImageView.isHidden = true
        photoImageView.clipsToBounds = true
    }
    
    
    //MARK: - Configure
    func configureFeedCell(_ imageUrlString: String, _ postType: MediaTypes) {
        setPhoto(photoURL: imageUrlString)
        
        switch postType {
        case .carousel:
            carouselImageView.isHidden = false
        default:
            carouselImageView.isHidden = true
        }
    }
    
    private func setPhoto(photoURL: String) {
        self.photoImageView.contentMode = .scaleAspectFill
        
        if let url = URL(string: photoURL) {
            
            let cache = ImageCache(name: Constants.Storage.mediaCache)
            let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 200 * UIScreen.main.scale, height: 200 * UIScreen.main.scale), mode: .aspectFit)

            self.photoImageView.kf.setImage(with: url,
                                            placeholder: UIImage(named: "placeholder_image"),
                                            options: [.transition(.fade(0.4)), .backgroundDecode, .targetCache(cache), .processor(resizingProcessor)]
//                                            , completionHandler:  { result in
//                switch result {
//                case .success(let item):
//                    print("Image size: \(item.image.size). Image cacheCost: \(item.image.cacheCost / 1024 / 1024) MB. Type: \(item.cacheType)" )
//                case .failure(_): break
//                }
//            }
            )
            
        } else {
            self.photoImageView.image = UIImage(named: "placeholder_image")
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height = (UIScreen.main.bounds.width / 3) - 2
        layoutAttributes.bounds.size.width = (UIScreen.main.bounds.width / 3) - 2
        return layoutAttributes
    }

}
