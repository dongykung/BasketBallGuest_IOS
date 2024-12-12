//
//  DatePickerSheet.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/9/24.
//

import SwiftUI

struct DatePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date = Date()
    @Binding private var bindingDate: Date?
    let action: () -> Void
    
    init(bindingDate: Binding<Date?>, action: @escaping () -> Void) {
        self._bindingDate = bindingDate
        self.action = action
    }
    var body: some View {
        VStack {
            TobBarSection(title: "날짜 선택") {
                dismiss()
            } action: {
                bindingDate = date
                action()
                dismiss()
            }
            .padding(.vertical)
            
            Rectangle()
                .fill(Color(uiColor: .systemGray6))
                .frame(height: 1)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
            
            DatePicker("날짜", selection: $date,in: Date()..., displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
        
            Spacer()
        }
    }
}

#Preview {
    DatePickerSheet(bindingDate: .constant(Date()), action: {
        
    })
}
