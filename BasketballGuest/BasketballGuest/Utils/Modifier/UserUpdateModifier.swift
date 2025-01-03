//
//  UserUpdateModifier.swift
//  BasketballGuest
//
//  Created by 김동경 on 1/3/25.
//

import SwiftUI

struct UserUpdateModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.basic)
            .padding(.vertical, 12)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            }
    }
}
