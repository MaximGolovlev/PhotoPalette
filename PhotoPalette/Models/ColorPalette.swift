//
//  ColorPalette.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI
import SwiftData

@Model
final class ColorPalette {
    var name: String
    var creationDate: Date
    @Attribute(.externalStorage) var thumbnail: Data?
    
    // Для хранения в SwiftData
    private var hexColorsString: String
    
    // Transient property - не сохраняется, вычисляется на лету
    @Transient var hexColors: [String] {
        get {
            hexColorsString.split(separator: ",").map(String.init)
        }
        set {
            hexColorsString = newValue.joined(separator: ",")
        }
    }
    
    init(name: String, hexColors: [String], thumbnail: Data? = nil) {
        self.name = name
        self.creationDate = Date()
        self.hexColorsString = hexColors.joined(separator: ",")
        self.thumbnail = thumbnail
    }
    
    // Computed property для удобства
    var colors: [AppColor] {
        hexColors.compactMap { hex in
            guard let uiColor = UIColor(hex: hex) else { return nil }
            return AppColor(uiColor: uiColor)
        }
    }
}
