//
//  SimpleNotificationView.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import UIKit

class SimpleNotificationView: UIView {

    //MARK: - Outlets
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var backView: UIView!

    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
        
    }
    
    
    //MARK: - Configure
    private func configureView() {
        backView.backgroundColor = .lightGray
        backView.alpha = 0.7
        textLabel.textColor = Constants.Colors.systemTextColor
        backView.layer.cornerRadius = Constants.ViewSettings.popupRadius
    }

}
