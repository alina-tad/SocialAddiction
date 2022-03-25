//
//  KFManager.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.03.2022.
//

import Foundation
import Kingfisher

class KFManager {
    
    class func storeToDisk(_ link: String) {
        if let url = URL(string: link) {
            if let data = try? Data(contentsOf: url) {
                KingfisherManager.shared.cache.storeToDisk(data, forKey: link)
            }
        }
    }
    
    class func cleanCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
    
}
