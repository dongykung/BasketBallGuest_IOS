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
            .modifier(ChipModifier())
    }
}

#Preview {
    PostChip(position: .smallForward)
}
