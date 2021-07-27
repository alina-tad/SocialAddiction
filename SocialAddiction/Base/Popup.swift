//
//  Popup.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 24.07.2021.
//

import Foundation
import SwiftMessages

class Popup {
    
    @objc class func close(_ sender : Any) {
        SwiftMessages.hide()
    }
    
    class func showSimpleNotificationView(_ text: String) {
        
        if let view = Bundle.main.loadNibNamed("SimpleNotificationView", owner: nil, options: nil)?.first as? SimpleNotificationView {
            
            view.textLabel.text = text
            
            var config = SwiftMessages.Config()
            config.presentationStyle = .bottom
            config.duration = .automatic
            config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            config.duration = .forever
            config.interactiveHide = true
            
            SwiftMessages.pauseBetweenMessages = 1
            SwiftMessages.show(config: config, view: view)
            
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        }
    }
    
}
