//
//  DescriptionViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import Foundation

class GuestDescriptionViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var description: String = ""
}
