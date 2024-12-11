//
//  ButtonType.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import SwiftUI

struct BorderButton: View {
    
    let buttonText: ButtonText
    let disabled: Bool
    let action: () -> Void
    
    init(
        buttonText: ButtonText,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.buttonText = buttonText
        self.disabled = disabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if disabled {
                    ProgressView()
                }
                Text(buttonText.rawValue)
                    .font(.semibold20)
                    .padding()
                    .foregroundStyle(.basic)
            }
            .frame(maxWidth: .infinity)
            .clipShape(.rect(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.orange, lineWidth: 1)
            }
        }
        .animation(.spring, value: disabled)
        .disabled(disabled)
    }
}

#Preview {
    BorderButton(buttonText: .jump) {
        
    }
}
