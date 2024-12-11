//
//  ErrorView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/6/24.
//

import SwiftUI

struct ErrorView: View {
    
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .center) {
                Text("네트워크 오류")
                    .foregroundStyle(.basic)
                    .font(.semibold20)
                    .padding(.bottom, 8)
                
                Text("인터넷 연결을 확인하고 다시")
                    .font(.regular16)
                    .foregroundStyle(.secondary)
                
                Text("시도해 주세요.")
                    .font(.regular16)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                
                Button(action: action) {
                    Text("재시도")
                        .font(.regular18)
                        .foregroundStyle(.blue)
                }
                
            }
            Spacer()
        }
    }
}

#Preview {
    ErrorView() {}
}
