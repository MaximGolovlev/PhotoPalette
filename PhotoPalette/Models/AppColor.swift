//
//  AppColor.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI

struct AppColor: Identifiable, Hashable {
    let id = UUID()
    let color: Color
    let hex: String
    let rgb: String
    
    // Для удобной инициализации из UIColor
    init(uiColor: UIColor) {
        self.color = Color(uiColor)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let red = Int(r * 255)
        let green = Int(g * 255)
        let blue = Int(b * 255)
        
        self.hex = String(format: "#%02X%02X%02X", red, green, blue)
        self.rgb = "rgb(\(red), \(green), \(blue))"
    }
}