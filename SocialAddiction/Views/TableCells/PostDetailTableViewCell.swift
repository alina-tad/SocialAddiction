//
//  FeedTableViewCell.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.07.2021.
//

import UIKit
import Kingfisher
import SnapKit

class PostDetailTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var carouselImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    //MARK: - Configure
    
    func configureSubviews() {
        selectionStyle = .none
        carouselImageView.image = UIImage(named: "carousel")
        carouselImageView.isHidden = true
        captionLabel.textColor = Constants.Colors.systemTextColor
        photoImageView.contentMode = .scaleAspectFit
        selectionStyle = .none
    }
    
    func configure(model: UserMediaModel, postType: MediaTypes) {
        captionLabel.attributedText = boldPartOfString(boldText: model.username, normalText: model.caption)
        setPhoto(photoURL: model.mediaUrl)
        
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
    
    
    //
    func boldPartOfString(boldText: String, normalText: String,_ fontSize: CGFloat = 14) -> NSAttributedString {
        
        let boldText = boldText
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrs)
        
        let normalText = " \(normalText)"
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        return attributedString
    }

    
}


