//
//  TabView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var chatRoomStore: ChatRoomStore = ChatRoomStore()
    
    var body: some View {
        TabView {
            GuestView()
                .tabItem {
                    Label("게스트", systemImage: "basketball")
                        .bold()
                }
            
            
            ChatRoomListView()
                .tabItem {
                    Label("채팅", systemImage: "message.badge.rtl")
                        .bold()
                }
                .badge(chatRoomStore.totalUnreadCount)
                .environmentObject(chatRoomStore)
            
            ManageView()
                .tabItem {
                    Label("관리", systemImage: "list.bullet.clipboard.fill")
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
