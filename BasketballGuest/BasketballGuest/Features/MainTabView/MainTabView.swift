//
//  TabView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GuestView()
                .tabItem {
                    Label("게스트", systemImage: "basketball")
                        .bold()
                }
            
            
            ChatRoomListView()
                .tabItem {
                    Label("채팅", systemImage: "bubble")
                        .bold()
                }
            
            
            MyPageView()
                .tabItem {
                    Label("마이", systemImage: "person.circle")
                        .bold()
                }
            
        }
    }
}

#Preview {
    MainTabView()
}
