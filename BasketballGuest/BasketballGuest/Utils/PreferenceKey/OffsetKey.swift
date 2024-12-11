//
//  OffsetKey.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/9/24.
//

import SwiftUI

struct PostOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct PostOffsetHelper: ViewModifier {
    
    
    var onChange: (CGFloat, CGFloat) -> Void
    @State var currentOffset: CGFloat = 0
    @State var previousOffset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    let minY = geometry.frame(in: .named("SCROLL")).minY
                    Color.clear
                        .preference(key: PostOffsetKey.self, value: minY)
                        .onPreferenceChange(PostOffsetKey.self) { value  in
                            previousOffset = currentOffset
                            currentOffset = value
                            onChange(previousOffset, currentOffset)
                        }
                }
            }
        
    }
}
