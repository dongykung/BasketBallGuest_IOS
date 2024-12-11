//
//  GuestListView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/9/24.
//

import SwiftUI

struct GuestListView: View {
    
    @Binding private var path: NavigationPath
    @ObservedObject private var viewModel: GuestViewModel
    
    @State private var headerHeight: CGFloat = 0
    @State private var headerOffset: CGFloat = 0
    @State private var lastHeaderOffset: CGFloat = 0
    @State private var direction: SwipeDirection = .none
    @State private var shiftOffset: CGFloat = 0
    
    @State private var isDateFilterSheet: Bool = false
    @State private var isPositionFilterSheet: Bool = false
    
    init(path: Binding<NavigationPath>, viewModel: GuestViewModel) {
        self._path = path
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                ForEach(viewModel.guestPost, id: \.documentId) { post in
                    GuestListItemView(post: post) {
                        path.append(post)
                    }
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentPost: post)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }
            }
            .padding(.top, headerHeight)
            .offsetY { previous, current in
                if previous > current {
                    if direction != .up && current < 0 {
                        shiftOffset = current - headerOffset
                        direction = .up
                        lastHeaderOffset = headerOffset
                    }
                    let offset = current < 0 ? (current - shiftOffset) : 0
                    headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                } else {
                    if direction != .down {
                        shiftOffset = current
                        direction = .down
                        lastHeaderOffset = headerOffset
                    }
                    let offset = lastHeaderOffset + (current - shiftOffset)
                    headerOffset = (offset > 0 ? 0 : offset)
                }
            }
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .top) {
            headerView
                .anchorPreference(key: HeaderBoundsKey.self, value: .bounds) { $0 }
                .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                    GeometryReader { proxy in
                        if let anchor = value {
                            Color.clear
                                .onAppear {
                                    headerHeight = proxy[anchor].height
                                }
                        }
                    }
                }
                .offset(y: -headerOffset < headerHeight ? headerOffset : (headerOffset < 0 ? headerOffset : 0))
        }
        .padding(.bottom)
        .background(Color(uiColor: .systemGray6))
        .sheet(isPresented: $isDateFilterSheet) {
            DatePickerSheet(bindingDate: $viewModel.guestFilter.selectedDate) {
                viewModel.setfilterDate()
            }
            .presentationDetents([.fraction(0.6), .fraction(0.7)])
            .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $isPositionFilterSheet) {
            PositionPicker(selectedPositions: $viewModel.guestFilter.selectedPosition) {
                viewModel.setfilterDate()
            }
            .presentationDetents([.fraction(0.6), .fraction(0.7)])
            .presentationDragIndicator(.hidden)
        }
    }
    
    @ViewBuilder
    var headerView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                Button {
                    
                } label: {
                    Label("내 주변", systemImage: "mappin.and.ellipse.circle")
                        .filterLabelStyle(selected: viewModel.guestFilter.isNearBy)
                }
                
                Button {
                    isDateFilterSheet.toggle()
                } label: {
                    Label(viewModel.guestFilter.selectedDate?.monthAndDayFormatted ?? "날짜", systemImage: "calendar")
                        .filterLabelStyle(selected: viewModel.guestFilter.selectedDate != nil)
                }
                
                Button {
                    isPositionFilterSheet.toggle()
                } label: {
                    Label(viewModel.guestFilter.selectedPosition.filteredText, systemImage: "basketball")
                        .filterLabelStyle(selected: !viewModel.guestFilter.selectedPosition.isEmpty)
                }
                Spacer()
            }
            .background(.clear)
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}

