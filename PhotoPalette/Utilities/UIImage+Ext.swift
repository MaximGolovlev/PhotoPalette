//
//  File.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//

import UIKit

// Расширение для UIImage
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// Расширение для UIColor для работы с HEX
extension UIColor {
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        guard hexString.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// Расширения для UIColor
extension UIColor {
    /// Вычисляет расстояние между цветами в RGB пространстве
    func distance(to other: UIColor) -> CGFloat {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let dr = r1 - r2
        let dg = g1 - g2
        let db = b1 - b2
        
        return sqrt(dr * dr + dg * dg + db * db)
    }
    
    /// Проверяет, не слишком ли темный цвет
    var isTooDark: Bool {
        var brightness: CGFloat = 0
        self.getWhite(&brightness, alpha: nil)
        return brightness < 0.1
    }
    
    /// Проверяет, не слишком ли светлый цвет
    var isTooLight: Bool {
        var brightness: CGFloat = 0
        self.getWhite(&brightness, alpha: nil)
        return brightness > 0.9
    }
    
    /// Проверяет, не является ли цвет серым (низкая насыщенность)
    var isGray: Bool {
        var saturation: CGFloat = 0
        self.getHue(nil, saturation: &saturation, brightness: nil, alpha: nil)
        return saturation < 0.1
    }
}
