//
//  Toast.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import Foundation

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}
