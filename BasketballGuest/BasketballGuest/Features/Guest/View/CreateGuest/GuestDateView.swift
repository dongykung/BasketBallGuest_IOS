//
//  DateView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import SwiftUI

struct GuestDateView: View {
    
    @ObservedObject private var viewModel: GuestDateViewModel
    let action: () -> Void
    private let errorMsg: String = "시작 시간이 종료 시간보다 빠를 수 없습니다."
    
    init(viewModel: GuestDateViewModel, action: @escaping () -> Void) {
        self.viewModel = viewModel
        self.action = action
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("날짜 및 시간")
                    .font(.semibold18)
                
                DatePicker(
                    "날짜",
                    selection: $viewModel.startTime,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .onChange(of: viewModel.startTime) { new in
                    viewModel.updateEndTimeDate()
                }
                .labelsHidden()
                .datePickerStyle(.graphical)
                
                HStack {
                    DatePicker(
                        "시작시간",
                        selection: $viewModel.startTime,
                        in: Date()...,
                        displayedComponents: [.hourAndMinute]
                    )
                    .font(.regular16)
                }
                
                HStack {
                    DatePicker(
                        "종료시간",
                        selection: $viewModel.endTime,
                        in: Date()...,
                        displayedComponents: [.hourAndMinute]
                    )
                    .font(.regular16)
                }
                .padding(.bottom)
            
                BasicButton(buttonText: .next) {
                    if viewModel.startTime > viewModel.endTime {
                        viewModel.showToastMsg(msg: errorMsg)
                        return
                    }
                    action()
                }
            }
            .toastView(toast: $viewModel.toast)
        }
    }
}

#Preview {
    GuestDateView(viewModel: .init()) {
        
    }
    .padding()
}
