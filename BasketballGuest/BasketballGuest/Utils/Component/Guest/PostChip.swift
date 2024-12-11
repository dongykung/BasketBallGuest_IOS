//
//  PostChip.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/7/24.
//

import SwiftUI

struct PostChip: View {
    
    let position: Position
    
    var body: some View {
        Text(position.rawValue)
            .foregroundStyle(.accent)
            .font(.semibold12)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(.chipbackground)
            .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    PostChip(position: .smallForward)
}
