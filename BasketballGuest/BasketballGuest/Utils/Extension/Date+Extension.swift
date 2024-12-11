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
}
