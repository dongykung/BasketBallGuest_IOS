//
//  DescriptionView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import SwiftUI

struct GuestDescriptionView: View {
    
    @FocusState private var field: Field?
    @ObservedObject private var viewModel: GuestDescriptionViewModel
    let action: () -> Void
    private let titleLimitCharCount = 30
    private let descriptionLimitCharCount = 150
    
    enum Field: Hashable {
        case title
        case description
    }
    
    init(
        viewModel: GuestDescriptionViewModel,
        action: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.action = action
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment:. leading, spacing: 20) {
                HStack {
                    Text("제목")
                        .font(.semibold18)
                    Text("(최소 3자 이상)")
                        .foregroundStyle(.secondary)
                        .font(.medium11)
                }
                   
                
                VStack {
                    BasicTextField(
                        text: $viewModel.title,
                        placeholder: "예) 주말 농구 한 판 하실 분!"
                    )
                    .focused($field, equals: .title)
                    .onSubmit {
                        field = .description
                    }
                    .onChange(of: viewModel.title) { new in
                        if new.count > titleLimitCharCount {
                            viewModel.title = String(new.prefix(titleLimitCharCount))
                        }
                    }
                    .padding(.bottom, 8)
                    
                    Text("\(viewModel.title.count)/\(titleLimitCharCount)")
                        .foregroundStyle(viewModel.title.count < titleLimitCharCount ? Color(uiColor: .systemGray3) : .red)
                        .font(.regular14)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom)
                
                
                HStack {
                    Text("상세 내용")
                        .font(.semibold18)
                    Text("(최소 10자 이상)")
                        .foregroundStyle(.secondary)
                        .font(.medium11)
                }
                 
                VStack {
                    BasicTextEditor(
                        text: $viewModel.description,
                        placeholder: "예) 즐겁게 즐농 하실 분 구합니다~"
                    )
                    .focused($field, equals: .description)
                    .onChange(of: viewModel.description) { new in
                        if new.count > descriptionLimitCharCount {
                            viewModel.description = String(new.prefix(descriptionLimitCharCount))
                        }
                    }
                    .padding(.bottom, 8)
                    
                    Text("\(viewModel.description.count)/\(descriptionLimitCharCount)")
                        .foregroundStyle(viewModel.description.count < descriptionLimitCharCount ? Color(uiColor: .systemGray3) : .red)
                        .font(.regular14)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.bottom)
                
                BasicButton(
                    buttonText: .next,
                    disabled: viewModel.title.count < 2 || viewModel.description.count < 10
                ) {
                    action()
                }
            }
        }
        .onTapGesture {
            field = nil
        }
    }
}

#Preview {
    GuestDescriptionView(viewModel: .init()) {
        
    }
}
