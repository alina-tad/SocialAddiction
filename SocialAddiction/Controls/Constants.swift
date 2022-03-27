//
//  Constants.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 23.07.2021.
//

import UIKit

struct Constants {
    
    struct SecurityKeys {
        static let authCodeKey               = "socialAddiction.secure.oauth.code.key"
        static let getCodeKey                = "get.socialAddiction.secure.code.key"
        static let token                     = "socialAddiction.secure.token"
    }
    
    struct UserKeys {
        static let userID                    = "socialAddiction.user.key.userID"
    }
    
    struct Storage {
        static let mediaCache                = "media.cache.key"
    }
    
    struct ViewSettings {
        static let cornerRadius: CGFloat     = 13.0
        static let popupRadius: CGFloat      = 20.0
    }
    
    struct ProgressIndicator {
        static let size: CGFloat             = 50
        static let transform                 = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    struct Colors {
        static  let systemTextColor          = UIColor { color in
            switch color.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
        
        static  let systemNavigationBarColor = UIColor { color in
            switch color.userInterfaceStyle {
            case .dark:
                return UIColor.black
            default:
                return UIColor.white
            }
        }
        
    }
    
}
