//
//  UIApplication+Extension.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/25/24.
//
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
