//
//  TobBarSection.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/9/24.
//

import SwiftUI

struct TobBarSection: View {
    
    let title: String
    let cancel: () -> Void
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button {
                cancel()
            } label: {
                Image(systemName: "xmark")
                    .tint(.basic)
                    .bold()
            }
            Spacer()
            Text(title)
                .font(.semibold18)
            Spacer()
            Button {
                action()
            } label: {
                Text("완료")
                    .foregroundStyle(.basic)
                    .font(.medium18)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    TobBarSection(title: "날짜선택") {
        
    } action: {
        
    }
}
