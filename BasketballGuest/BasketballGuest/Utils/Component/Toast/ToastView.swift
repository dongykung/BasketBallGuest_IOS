//
//  ToastView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.color)
            
            Text(message)
                .font(.regular14)
                .foregroundColor(.primary)
            
            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(style.color)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(Color(uiColor: .systemGray5).opacity(0.85))
        .clipShape(.rect(cornerRadius: 8))
        .padding(.horizontal)
    }
}

#Preview {
    ToastView(style: .warning, message: "토스트 메시지에 성공") {
        
    }
}
