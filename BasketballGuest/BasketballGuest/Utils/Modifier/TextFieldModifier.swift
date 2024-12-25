//
//  TextFieldModifier.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/25/24.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(4)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
                    .foregroundStyle(.clear)
            }
    }
}
