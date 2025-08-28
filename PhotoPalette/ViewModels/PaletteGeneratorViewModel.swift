//
//  PaletteGeneratorViewModel.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI
import PhotosUI
import SwiftData

@MainActor
class PaletteGeneratorViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem?
    @Published var extractedColors: [AppColor] = []
    @Published var isProcessing = false
    @Published var paletteName = ""
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadImage() async {
        guard let selectedItem = selectedItem else { return }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            if let data = try await selectedItem.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    await extractColors(from: uiImage)
                }
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
    
    func extractColors(from image: UIImage) async {
        extractedColors = await ColorCalculator.shared.extractDominantColors(from: image)
    }
    
    func savePalette() {
        guard !extractedColors.isEmpty, !paletteName.isEmpty else { return }
        
        let hexColors = extractedColors.map { $0.hex }
        let thumbnailData = selectedImage?.jpegData(compressionQuality: 0.1)
        
        let palette = ColorPalette(
            name: paletteName,
            hexColors: hexColors,
            thumbnail: thumbnailData
        )
        
        modelContext.insert(palette)
        
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        // Сбрасываем состояние
        selectedImage = nil
        selectedItem = nil
        extractedColors = []
        paletteName = ""
        
        // Показываем какой-то feedback о успешном сохранении (можно добавить alert)
    }
    
    func cancelImageSelection() {
        selectedImage = nil
        selectedItem = nil
        extractedColors = []
        paletteName = ""
    }
}
