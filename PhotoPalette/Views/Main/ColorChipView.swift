//
//  ColorChipView.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI

struct ColorChipView: View {
    let color: Color
    let hex: String
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(height: 60)
                .cornerRadius(8)
                .onTapGesture {
                    UIPasteboard.general.string = hex
                    showingAlert = true
                }
            
            Text(hex)
                .font(.system(.caption, design: .monospaced))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .alert("Copied!", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("HEX code \(hex) copied to clipboard")
        }
    }
}
