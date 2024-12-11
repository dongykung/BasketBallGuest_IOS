//
//  BasicTextField.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import SwiftUI

struct BasicTextField: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.medium18)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            }
    }
}

#Preview {
    BasicTextField(text: .constant("hello"), placeholder: "닉네임을 입력해 주세요.")
}
