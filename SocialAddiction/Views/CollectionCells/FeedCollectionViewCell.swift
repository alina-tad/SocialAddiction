//
//  FeedCollectionViewCell.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit

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
        if let url = URL(string: photoURL) {
            self.photoImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "placeholder_image"),
                                     options: [ .transition(.fade(0.2)), .backgroundDecode])
            self.photoImageView.contentMode = .scaleAspectFill
        } else {
            self.photoImageView.image = UIImage(named: "placeholder_image")
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height = (UIScreen.main.bounds.width / 3) - 4
        layoutAttributes.bounds.size.width = (UIScreen.main.bounds.width / 3) - 4
        return layoutAttributes
    }

}
