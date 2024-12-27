//
//  MyPageView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var authStore: AuthStore
    var body: some View {
        Button {
            authStore.logout()
        } label: {
            Text("logout")
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(AuthStore())
}
