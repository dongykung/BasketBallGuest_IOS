//
//  UserError.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import Foundation

enum UserError: Error, LocalizedError {
    case userNotFound
    case invalidate
    case decodingError(Error)
    case networkError(Error)
    case permissionDenied
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자 정보를 찾을 수 없습니다."
        case .decodingError(let error):
            return "사용자 정보를 해석하는 데 실패했습니다: \(error.localizedDescription)"
        case .networkError(let error):
            return "네트워크 오류가 발생했습니다: \(error.localizedDescription)"
        case .permissionDenied:
            return "위치 권한이 거부되었습니다."
        case .unknownError(let error):
            return "알 수 없는 오류가 발생했습니다: \(error.localizedDescription)"
        case .invalidate:
            return "로그인 정보를 잃었습니다."
        }
    }
}
