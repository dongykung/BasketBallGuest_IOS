//
//  PositionButton.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct PositionButton: View {
    
    let position: String
    let selected: Bool
    let action: () -> Void
    
    init(position: String, selected: Bool, action: @escaping () -> Void) {
        self.position = position
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(position)
                .foregroundStyle(selected ? .white : .basic)
                .font(selected ? .semibold18 : .regular18)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(selected ? .orange : Color(uiColor: .systemGray5))
        .clipShape(.rect(cornerRadius: 12))
    }
}

#Preview {
    PositionButton(position: "스몰 포워드", selected: true) {
        
    }
}
