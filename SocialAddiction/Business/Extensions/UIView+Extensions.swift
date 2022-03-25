//
//  UIView+Extensions.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.03.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func addGradient(_ colors: [UIColor] = [UIColor.systemGreen, UIColor.yellow]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.locations = [0.0, 1.0]
        gradient.colors = colors.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
    }
}
