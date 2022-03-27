//
//  KFManager.swift
//  SocialAddiction
//
//  Created by Alina Topilo on 25.03.2022.
//

import Foundation
import Kingfisher

class KFManager {
    
    //MARK: - Actions
    class func cleanCache() {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        ImageCache(name: "images_disk_cache").clearDiskCache(completion: nil)
    }
    
}
