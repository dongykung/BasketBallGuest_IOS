//
//  BasicButton.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import SwiftUI

enum ButtonText: String {
    case next = "다음"
    case complete = "완료"
    case jump = "건너뛰기"
    case cancel = "취소하기"
}

struct BasicButton: View {
    
    let buttonText: ButtonText
    let loading: Bool
    let disabled: Bool
    let action: () -> Void
    
    init(
        buttonText: ButtonText,
        loading: Bool = false,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.buttonText = buttonText
        self.loading = loading
        self.disabled = disabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                if loading {
                    ProgressView()
                }
                Text(buttonText.rawValue)
                    .font(.semibold20)
                    .padding()
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .background(disabled ? .orange.opacity(0.5) : .orange)
            .clipShape(.rect(cornerRadius: 12))
        }
        .animation(.spring, value: disabled)
        .disabled(disabled)
    }
}

#Preview {
    BasicButton(buttonText: .next, disabled: true) {
        
    }
}
