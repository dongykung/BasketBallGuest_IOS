//
//  BodyInfoViewModel.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/4/24.
//

import Foundation

class BodyInfoViewModel: ObservableObject {
    
    @Published var height: Int? = 175
    @Published var weight: Int? = 75
    @Published var isHeightPickerMode: Bool = true
    @Published var isWeightPickerMode: Bool = true
    @Published var heightRange = 150...200
    @Published var weightRange = 50...110
    @Published var heightText: String = "175"
    @Published var weightText: String = "75"
    @Published var heightErrorMessage: String = ""
    @Published var weightErroMessage: String = ""
    
    let moveNextStep: () -> Void
    
    init(moveNextStep: @escaping () -> Void) {
        self.moveNextStep = moveNextStep
    }
    
    func heightInputModeChange() {
        if isHeightPickerMode {
            heightPickerConvertText()
        } else {
            heightTextConvertPicker()
        }
        isHeightPickerMode = !isHeightPickerMode
    }
    
    func weightInputModeChange() {
        if isWeightPickerMode {
            weightPickerConvertText()
        } else {
            weightTextConvertPicker()
        }
        isWeightPickerMode = !isWeightPickerMode
    }
    
    func heightPickerConvertText() {
        guard let height = height else { return }
        heightText = "\(height)"
        isValidateBodyInfo()
    }
    
    func heightTextConvertPicker() {
        guard let height = Int(heightText) else {
            self.height = 175
            return
        }
        if !heightRange.contains(height) {
            self.height = 175
            return
        }
        self.height = height
    }
    
    func weightPickerConvertText() {
        guard let weight = weight else { return }
        weightText = "\(weight)"
        isValidateBodyInfo()
    }
    
    func weightTextConvertPicker() {
        guard let weight = Int(weightText) else {
            self.weight = 75
            return
        }
        if !weightRange.contains(weight) {
            self.weight = 75
            return
        }
        self.weight = weight
    }
    
    func isValidateBodyInfo() {
        guard let height = Int(heightText) else {
            self.heightErrorMessage = "유효한 숫자를 입력해 주세요."
            return
        }
        
        guard let weight = Int(weightText) else {
            self.weightErroMessage = "유효한 숫자를 입력해 주세요."
            return
        }
        
        if !heightRange.contains(height) {
            self.heightErrorMessage = "\(heightRange)의 숫자를 입력해 주세요."
        } else {
            self.heightErrorMessage = ""
        }
        
        if !weightRange.contains(weight) {
            self.weightErroMessage = "\(weightRange)의 숫자를 입력해 주세요."
        } else {
            self.weightErroMessage = ""
        }
    }
    
    func skip() {
        self.height = nil
        self.weight = nil
        moveNextStep()
    }
    
    func nextStep() {
        moveNextStep()
    }
}
