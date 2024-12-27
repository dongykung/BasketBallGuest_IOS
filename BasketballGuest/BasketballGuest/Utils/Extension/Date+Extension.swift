//
//  Date+Extension.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/7/24.
//

import Foundation

extension Date {
    var guestStartTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM.dd EEEE a h:mm"
        return formatter.string(from: self)
    }
    
    var guestEntTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "h:mm"
        return formatter.string(from: self)
    }
    
    var monthAndDayFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM.dd"
        return formatter.string(from: self)
    }
    
    var guestFullTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY.MM.dd EEEE a h:mm"
        return formatter.string(from: self)
    }
    
    var chatSectionFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY년.MM월.dd일"
        return formatter.string(from: self)
    }
    
    var chatTimeFormatted: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: self)
    }
    
    var formattedTimeAgo: String {
        let now = Date()
        let calendar = Calendar.current

        let components = calendar.dateComponents([.minute, .hour, .day], from: self, to: now)

        if let day = components.day, day > 0 {
            if day == 1 {
                return "어제"
            } else {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.dateFormat = "M월 d일 E요일"
                return formatter.string(from: self)
            }
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금"
        }
    }
}
