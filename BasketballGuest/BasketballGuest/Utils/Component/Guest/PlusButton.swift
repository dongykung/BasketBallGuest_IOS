//
//  PlusButton.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct PlusButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .bold()
        }
    }
}

#Preview {
    PlusButton() {}
}
