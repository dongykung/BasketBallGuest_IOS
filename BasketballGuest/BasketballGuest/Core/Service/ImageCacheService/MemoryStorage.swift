//
//  MemoryStorage.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/13/24.
//

import UIKit

protocol MemoryStorage {
    func value(for key: String) -> UIImage?
    func store(for key: String, image: UIImage)
}

class MemoryStorageImpl: MemoryStorage {
    
    var cache = NSCache<NSString, UIImage>()
    
    func value(for key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
}
