//
//  MyParticipantView.swift
//  BasketballGuest
//
//  Created by 김동경 on 1/5/25.
//

import SwiftUI

struct MyParticipantView: View {
    @ObservedObject var viewModel: ManageViewModel
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            switch viewModel.myParticipantLoadState {
            case .none, .loading:
                LoadingView()
            case .completed:
                MyParticipantListView
            case .failed:
                ErrorView {
                    Task {
                        await viewModel.fetchMyParticipant()
                    }
                }
            }
        }.overlay {
            if viewModel.myParticipantLoadState == .completed && viewModel.myParticipantStatus.isEmpty {
                Text("내 신청 내역이 없습니다.")
            }
        }
    }
    
    @ViewBuilder
    private var MyParticipantListView: some View {
        ForEach(viewModel.myParticipantStatus, id: \.id) { status in
            MyParticipantItemView(participantStatus: status) {
                path.append(status.post)
            }
            .padding(8)
        }
    }
}

struct MyParticipantItemView: View {
    let participantStatus: MyParticipantStatus
    let action: () -> Void
    
    init(participantStatus: MyParticipantStatus, action: @escaping () -> Void) {
        self.participantStatus = participantStatus
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Text(participantStatus.post.title)
                    .foregroundStyle(.basic)
                    .font(.semibold20)
                Label("\(participantStatus.post.startDate.guestStartTimeFormatted) ~ \(participantStatus.post.endDate.guestEntTimeFormatted)", systemImage: "fitness.timer")
                    .font(.medium17)
                    .foregroundStyle(.gray)
                
                HStack {
                    Label("\(participantStatus.post.placeAddress) \(participantStatus.post.placeName)", systemImage: "map")
                        .lineLimit(1)
                        .font(.medium17)
                        .foregroundStyle(.gray)
                    if let flag = participantStatus.post.parkFlag, flag == "1" {
                        Image(systemName: "parkingsign.circle")
                            .foregroundStyle(.blue)
                    }
                }
                switch participantStatus.status {
                case .owner, .none:
                    EmptyView()
                case .guest:
                    Text("게스트")
                        .foregroundStyle(.green)
                case .apply:
                    Text("신청중")
                        .foregroundStyle(.blue)
                case .rejected:
                    Text("거절됨")
                        .foregroundStyle(.red)
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
    MyParticipantView(viewModel: .init(), path: .constant(.init()))
}
