//
//  ResizableTextField.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/25/24.
//

import SwiftUI

struct ResizableTextField: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return ResizableTextField.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isEditable = true
        view.isScrollEnabled = true
        view.font = .systemFont(ofSize: 16)
        view.textColor = .basic
        view.contentSize.height = height
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if self.text.isEmpty  {
            uiView.text = ""
        }
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: ResizableTextField
        
        init(parent: ResizableTextField) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if self.parent.text == "" {
                textView.text = ""
                textView.textColor = .basic
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
    }
}
