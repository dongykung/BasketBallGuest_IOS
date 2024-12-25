//
//  GuestDetailInfoView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/24/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct GuestDetailInfoView: View {
    
    let post: GuestPost
    let copy: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            DateSection(startDate: post.startDate)
            
            AddressSection(placeAddress: post.placeAddress, placeName: post.placeName, copy: copy)
            
            MemberSection(currentMemberCount: post.currentMemberCount, maxMemberCount: post.memberCount)
            
            PositionSection(positions: post.positions)
            
            DetailExplainView(explain: post.description)
                .padding(.bottom, 32)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}


fileprivate struct DateSection: View {
    
    let startDate: Date
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "calendar.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 3) {
                Text("일시")
                    .foregroundStyle(.gray)
                Text(startDate.guestFullTimeFormatted)
                    .font(.medium18)
            }
            Spacer()
        }
    }
}

fileprivate struct AddressSection: View {
    
    let placeAddress: String
    let placeName: String
    let copy: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "map.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 3) {
                Text("장소")
                    .foregroundStyle(.gray)
                Text("\(placeAddress)\n\(placeName)")
                    .font(.medium18)
            }
            Spacer()
            Button {
                let clipboard = UIPasteboard.general
                clipboard.setValue(placeAddress, forPasteboardType: UTType.plainText.identifier)
                copy()
            } label: {
                Text("복사")
                    .foregroundStyle(.blue)
                    .padding(.horizontal,8)
                    .padding(.vertical,6)
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

fileprivate struct MemberSection: View {
    let currentMemberCount: Int?
    let maxMemberCount: Int
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "person.3")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 3) {
                Text("모집 인원")
                    .foregroundStyle(.gray)
                Text("\(currentMemberCount ?? 0)/\(maxMemberCount)")
                    .font(.medium18)
            }
            Spacer()
        }
    }
}

fileprivate struct PositionSection: View {
    
    let positions: [Position]
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "basketball")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.gray)
                .frame(width: 30, height: 30)
            VStack(alignment: .leading, spacing: 6) {
                Text("모집 포지션")
                    .foregroundStyle(.gray)
                FlowLayout {
                    ForEach(positions, id: \.id) { position in
                        PostChip(position: position)
                            .padding(3)
                    }
                }
            }
        }
    }
}

fileprivate struct DetailExplainView: View {
    let explain: String
    
    var body: some View {
        VStack {
            Text("상세 내용")
                .font(.semibold18)
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(explain)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    GuestDetailInfoView(post: dummyPost) {}
}
