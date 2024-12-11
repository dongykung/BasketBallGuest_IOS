//
//  DateViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/5/24.
//

import Foundation

class GuestDateViewModel: ObservableObject {
    @Published var toast: Toast?
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date()
    
    func showToastMsg(msg: String) {
        toast = Toast(style: .warning, message: msg)
    }
    
    func updateEndTimeDate() {
        let calendar = Calendar.current
        
        // endTime에서 시간(시, 분, 초) 추출
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: endTime)
        
        // startTime에서 날짜(년, 월, 일) 추출
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: startTime)
        
        // startTime의 날짜와 endTime의 시간을 결합하여 새로운 endTime 생성
        if let updatedEndTime = calendar.date(from: DateComponents(year: dateComponents.year,
                                                                   month: dateComponents.month,
                                                                   day: dateComponents.day,
                                                                   hour: timeComponents.hour,
                                                                   minute: timeComponents.minute,
                                                                   second: timeComponents.second)) {
            endTime = updatedEndTime
        }
    }
}
