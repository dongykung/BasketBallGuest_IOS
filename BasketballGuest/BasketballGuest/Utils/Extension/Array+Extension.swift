//
//  Array+Extension.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/10/24.
//

import Foundation

extension Array where Self == [Position] {
    
    var filteredText: String {
        switch self.count {
        case 0:
            "포지션"
        case 1:
            "\(self.first?.rawValue ?? "")"
        case 2...self.count:
            "\(self.last?.rawValue ?? "") 외 \(self.count - 1)"
        default:
            "포지션"
        }
    }
}
