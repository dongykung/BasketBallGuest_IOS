//
//  BodyInfoView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import SwiftUI

struct BodyInfoView: View {
    
    @ObservedObject var viewModel: BodyInfoViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("신체정보 입력")
                    .font(.semibold28)
                
                Text("신장과 체중을 입력해 주세요.\n이 정보는 선택사항 입니다.")
                    .font(.regular18)
                    .foregroundStyle(.secondary)
                
                VStack {
                    UserBodyInfoHeaderView(title: "신장") {
                        viewModel.heightInputModeChange()
                    }
                    if viewModel.isHeightPickerMode {
                        Picker("신장", selection: $viewModel.height) {
                            ForEach(viewModel.heightRange, id: \.self) { height in
                                Text("\(height)cm").tag(height)
                            }
                        }
                        .pickerStyle(.wheel)
                    } else {
                        UserBodyInfoTextFieldView(
                            unit: "cm",
                            range: viewModel.heightRange,
                            text: $viewModel.heightText
                        ) {
                            viewModel.isValidateBodyInfo()
                        }
                        
                        if !viewModel.heightErrorMessage.isEmpty {
                            Text(viewModel.heightErrorMessage)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .animation(.smooth, value: viewModel.isHeightPickerMode)
                
                VStack {
                    UserBodyInfoHeaderView(title: "체중") {
                        viewModel.weightInputModeChange()
                    }
                    if viewModel.isWeightPickerMode {
                        Picker("체중", selection: $viewModel.weight) {
                            ForEach(viewModel.weightRange, id: \.self) { weight in
                                Text("\(weight)kg").tag(weight)
                            }
                        }
                        .pickerStyle(.wheel)
                    } else {
                        UserBodyInfoTextFieldView(
                            unit: "kg",
                            range: viewModel.weightRange,
                            text: $viewModel.weightText
                        ) {
                            viewModel.isValidateBodyInfo()
                        }
                        if !viewModel.weightErroMessage.isEmpty {
                            Text(viewModel.weightErroMessage)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                
                BorderButton(buttonText: .jump) {
                    viewModel.skip()
                }
                
                BasicButton(buttonText: .next) {
                    viewModel.nextStep()
                }
                .padding(.bottom)
            }
        }
        .scrollIndicators(.hidden)
    }
}

struct UserBodyInfoHeaderView: View {
    
    let title: String
    let action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.medium16)
            Spacer()
            Button(action: action) {
                Text("직접입력")
                    .font(.medium16)
            }
        }
    }
}

struct UserBodyInfoTextFieldView: View {
    
    let unit: String
    let range: ClosedRange<Int>
    @Binding var text: String
    let validate: () -> Void
    
    var body: some View {
        HStack {
            TextField("정보를 입력해 주세요.",text: $text)
                .onChange(of: text) { value in
                    let filtered = value.filter { "0123456789".contains($0) }
                    if value != filtered {
                        text = filtered
                    }
                    validate()
                }
                .font(.regular18)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .padding(.vertical)
            Text("\(unit)")
                .font(.regular18)
        }
    }
}

#Preview {
    BodyInfoView(viewModel: BodyInfoViewModel(moveNextStep: {
        
    }))
}
