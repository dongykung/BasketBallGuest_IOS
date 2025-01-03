//
//  HeightChangeSheet.swift
//  BasketballGuest
//
//  Created by 김동경 on 1/3/25.
//

import SwiftUI

struct BodyInfoChangeSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BodyInfoViewModel = BodyInfoViewModel(moveNextStep: {})
    let height: Int?
    let weight: Int?
    let action: (Int?, Int?) -> Void
   
    var body: some View {
        VStack {
            topBar
            UserBodyInputSection(viewModel: viewModel)
            Spacer()
        }
        .onAppear {
            viewModel.height = height == nil ? 175 : height
            viewModel.weight = weight == nil ? 75 : weight
        }
    }
    @ViewBuilder
    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.basic)
                    .bold()
            }
            Spacer()
            Button {
                action(viewModel.height, viewModel.weight)
                dismiss()
            } label: {
                Text("확인")
                    .bold()
                    .foregroundStyle(.basic)
                    .font(.regular16)
            }
            .disabled(!viewModel.heightErrorMessage.isEmpty || !viewModel.weightErroMessage.isEmpty)
        }
        .overlay {
            Text("신장/체중 변경")
        }
        .padding(.vertical)
    }
}
