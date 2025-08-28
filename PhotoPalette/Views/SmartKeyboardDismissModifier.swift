//
//  SmartKeyboardDismissModifier.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI

struct SmartKeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
           // .contentShape(Rectangle())
            .onTapGesture {
                dismissKeyboard()
            }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

extension View {
    func smartDismissKeyboard() -> some View {
        self.modifier(SmartKeyboardDismissModifier())
    }
}
