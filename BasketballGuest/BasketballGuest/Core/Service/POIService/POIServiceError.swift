//
//  POIServiceError.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/6/24.
//

import Foundation

enum POIServiceError: Error, LocalizedError {
    case invalidConfig
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case networkError
    case unknown
    
    var errorDescription: String {
        switch self {
        case .invalidConfig:
            return "오류가 발생했습니다, 다시 시도해 주세요."
        case .invalidURL:
            return "유효하지 않은 주소입니다."
        case .requestFailed:
            return "오류가 발생했습니다, 다시 시도해 주세요."
        case .decodingFailed:
            return "디코딩문제임 ㅋ"
        case .networkError:
            return "네트워크 상태가 원활하지 않습니다. 다시 시도해 주세요."
        case .unknown:
            return "오류가 발생했습니다, 다시 시도해 주세요."
        }
    }
}
