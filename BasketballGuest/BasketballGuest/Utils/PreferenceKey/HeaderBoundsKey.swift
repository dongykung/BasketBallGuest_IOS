//
//  HeaderBoundsKey.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/9/24.
//

import SwiftUI

struct HeaderBoundsKey: PreferenceKey {
    
    static var defaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}
