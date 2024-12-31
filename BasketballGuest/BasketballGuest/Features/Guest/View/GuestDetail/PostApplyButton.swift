//
//  PostApplyButton.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/30/24.
//

import SwiftUI

struct PostApplyButton: View {
    
    let loadState: LoadState
    let guestStatus: GuestStatus
    let error: () -> Void
    let action: (GuestStatus) -> Void
    
    init(loadState: LoadState, guestStatus: GuestStatus, error: @escaping () -> Void, action: @escaping (GuestStatus) -> Void) {
        self.loadState = loadState
        self.guestStatus = guestStatus
        self.error = error
        self.action = action
    }
    
    var body: some View {
        VStack {
            switch loadState {
            case .none, .loading:
                LoadButton()
            case .completed:
                ApplyButton(guestStatus: guestStatus) {
                    action(guestStatus)
                }
            case .failed:
                ErrorButton() {
                    error()
                }
            }
        }
    }
}

struct LoadButton: View {
    var body: some View {
        Button {} label: {
            ProgressView()
                .modifier(ApplyButtonModifier())
        }
        .disabled(true)
    }
}

struct ApplyButton: View {
    let guestStatus: GuestStatus
    let action: () -> Void
    
    init(guestStatus: GuestStatus, action: @escaping () -> Void) {
        self.guestStatus = guestStatus
        self.action = action
    }
    
    var body: some View {
        VStack {
            switch guestStatus {
            case .owner:
                ApplyButtonView(text: "신청자 관리", action: action)
            case .guest:
                ApplyButtonView(text: "게스트 취소", action: action)
            case .apply:
                ApplyButtonView(text: "신청취소", action: action)
            case .rejected, .none:
                ApplyButtonView(text: "신청하기", action: action)
            }
        }
    }
}

struct ErrorButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text("다시 시도")
                .modifier(ApplyButtonModifier())
        }
    }
}

struct ApplyButtonView: View {
    let text: String
    let action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    var body: some View {
        Button(action: action) {
            Text(text)
                .modifier(ApplyButtonModifier())
        }
    }
}

#Preview {
    PostApplyButton(loadState: .loading, guestStatus: .apply) {
        
    } action: { status in
    }
}
