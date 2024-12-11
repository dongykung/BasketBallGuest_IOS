//
//  View+Extension.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import SwiftUI

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
    
    func offsetY(completion: @escaping (CGFloat, CGFloat) -> Void) -> some View {
        self
            .modifier(PostOffsetHelper(onChange: completion))
    }
    
    func filterLabelStyle(selected: Bool) -> some View {
        self.modifier(FilterLabelModifier(selected: selected))
       }
}

