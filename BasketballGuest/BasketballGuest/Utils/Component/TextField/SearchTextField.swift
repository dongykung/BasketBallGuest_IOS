//
//  SearchTextField.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/6/24.
//

import SwiftUI

struct SearchTextField: View {
    
    let placeHolder: String
    @Binding var query: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeHolder, text: $query)
                .font(.regular18)
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
        .padding()
        .background(.searchcontainer)
        .clipShape(.rect(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .fill(.clear)
        )
    }
}

#Preview {
    SearchTextField(placeHolder:"장소명 또는 주소 검색", query: .constant(""))
}
