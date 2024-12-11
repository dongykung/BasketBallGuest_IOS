//
//  EmptyView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/7/24.
//

import SwiftUI

struct SearchEmptyView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("검색 결과가 존재하지 않습니다.")
                .font(.regular18)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

