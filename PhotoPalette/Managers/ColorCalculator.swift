//
//  ColorCalculator.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import UIKit
import SwiftUI

actor ColorCalculator {
    
    static let shared = ColorCalculator()
    
    private init() {}
    
    /// Основная функция для извлечения доминирующих цветов
    func extractDominantColors(from image: UIImage, count: Int = 5, minDistance: CGFloat = 0.15) -> [AppColor] {
        guard let resizedImage = image.resized(to: CGSize(width: 100, height: 100)),
              let cgImage = resizedImage.cgImage else {
            return []
        }
        
        // Анализ пикселей
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let totalBytes = height * bytesPerRow
        
        var pixelData = [UInt8](repeating: 0, count: totalBytes)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                               width: width,
                               height: height,
                               bitsPerComponent: 8,
                               bytesPerRow: bytesPerRow,
                               space: colorSpace,
                               bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Группировка цветов
        var colorCounts: [UIColor: Int] = [:]
        
        for y in 0..<height {
            for x in 0..<width {
                let index = (y * bytesPerRow) + (x * bytesPerPixel)
                let red = CGFloat(pixelData[index]) / 255.0
                let green = CGFloat(pixelData[index + 1]) / 255.0
                let blue = CGFloat(pixelData[index + 2]) / 255.0
                let alpha = CGFloat(pixelData[index + 3]) / 255.0
                
                let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                
                // Игнорируем слишком прозрачные и слишком темные/светлые пиксели
                if alpha > 0.5 && !color.isTooDark && !color.isTooLight {
                    colorCounts[color, default: 0] += 1
                }
            }
        }
        
        // Упрощенная k-means кластеризация
        let clusters = kMeansClustering(pixels: Array(colorCounts.keys), k: count)
        return clusters.map { AppColor(uiColor: $0) }
    }
    
    private func kMeansClustering(pixels: [UIColor], k: Int, iterations: Int = 10) -> [UIColor] {
        guard !pixels.isEmpty else { return [] }
        
        // Инициализируем центроиды случайными пикселями
        var centroids = Array(pixels.shuffled().prefix(k))
        
        for _ in 0..<iterations {
            var clusters: [[UIColor]] = Array(repeating: [], count: k)
            
            // Распределяем пиксели по ближайшим центроидам
            for pixel in pixels {
                var minDistance = CGFloat.greatestFiniteMagnitude
                var closestIndex = 0
                
                for (index, centroid) in centroids.enumerated() {
                    let distance = pixel.distance(to: centroid)
                    if distance < minDistance {
                        minDistance = distance
                        closestIndex = index
                    }
                }
                
                clusters[closestIndex].append(pixel)
            }
            
            // Пересчитываем центроиды
            for i in 0..<k {
                if !clusters[i].isEmpty {
                    centroids[i] = averageColor(of: clusters[i])
                }
            }
        }
        
        return centroids
    }
    
    private func averageColor(of colors: [UIColor]) -> UIColor {
        var totalRed: CGFloat = 0
        var totalGreen: CGFloat = 0
        var totalBlue: CGFloat = 0
        var totalAlpha: CGFloat = 0
        
        for color in colors {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            totalRed += red
            totalGreen += green
            totalBlue += blue
            totalAlpha += alpha
        }
        
        let count = CGFloat(colors.count)
        return UIColor(red: totalRed/count,
                      green: totalGreen/count,
                      blue: totalBlue/count,
                      alpha: totalAlpha/count)
    }
}



