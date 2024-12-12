//
//  GuestListItemView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/7/24.
//

import SwiftUI

struct GuestListItemView: View {
    
    let post: GuestPost
    let action: () -> Void
    
    init(post: GuestPost, action: @escaping () -> Void) {
        self.post = post
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Text(post.title)
                    .foregroundStyle(.basic)
                    .font(.semibold20)
                
                Label("\(post.startDate.guestStartTimeFormatted) ~ \(post.endDate.guestEntTimeFormatted)", systemImage: "fitness.timer")
                    .font(.medium17)
                    .foregroundStyle(.gray)
                
                HStack {
                    Label("\(post.placeAddress) \(post.placeName)", systemImage: "map")
                        .lineLimit(1)
                        .font(.medium17)
                        .foregroundStyle(.gray)
                    if let flag = post.parkFlag, flag == "1" {
                        Image(systemName: "parkingsign.circle")
                            .foregroundStyle(.blue)
                    }
                }
                
                HStack(alignment: .bottom, spacing: 12) {
                    FlowLayout {
                        ForEach(post.positions, id: \.id) { position in
                            PostChip(position: position)
                                .padding(2)
                        }
                    }
                    Spacer()
                    Text("\(post.currentMemberCount ?? 0)/\(post.memberCount)명")
                        .font(.medium14)
                        .foregroundStyle(.gray)
                        .padding(.trailing)
                        .padding(.bottom, 8)
                }
                
            }
            .padding()
            .background(.basicsecondary)
            .clipShape(.rect(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 3, y: 3)
        }
    }
}

#Preview {
    GuestListItemView(post: GuestPost(writerUid: "", title: "12.15 일요일 농구하실 분", description: "", date: Date(), startDate: Date(), endDate: Date(), memberCount: 5, positions: [.center, .pointGuard], lat: 12.4, lng: 12.4, placeName: "군포 국민체육센터", placeAddress: "경기 군포시 군포로 339" , parkFlag: "1", currentMemberCount: nil)) {}
}
