//
//  ToastStyle.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
}

extension ToastStyle {
    
    var color: Color {
        switch self {
        case .error:
                .red
        case .warning:
                .orange
        case .success:
                .green
        case .info:
                .blue
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
      }
}
