//
//  AxisTextField.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import SwiftUI

struct BasicTextEditor: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextEditor(text: $text)
            .font(.medium16)
            .padding(8)
            .frame(height: 150)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.gray, lineWidth: 1)
            }
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.secondary)
                        .font(.regular14)
                        .offset(x:10, y:15)
                }
            }
    }
}
