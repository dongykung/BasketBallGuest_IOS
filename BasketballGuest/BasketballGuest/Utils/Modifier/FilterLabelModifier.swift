//
//  FilterLabelModifier.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/9/24.
//

import SwiftUI

struct FilterLabelModifier: ViewModifier {
    
    let selected: Bool
    
    func body(content: Content) -> some View {
        content
            .font(selected ? .semibold16 : .regular16)
            .foregroundStyle(.basic)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(selected ? .accent.opacity(0.7) : Color.black.opacity(0.08))
            )
    }
}
