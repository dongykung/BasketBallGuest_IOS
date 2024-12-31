//
//  ChipModifier.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import SwiftUI

struct ChipModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.accent)
            .font(.semibold12)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.chipbackground)
            .clipShape(.rect(cornerRadius: 16))
    }
}

