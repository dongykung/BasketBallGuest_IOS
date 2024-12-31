//
//  ApplyButtonModifier.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import SwiftUI

struct ApplyButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .font(.semibold18)
            .foregroundStyle(.white)
            .background(.accent)
            .clipShape(.rect(cornerRadius: 12))
            .padding()
    }
}
