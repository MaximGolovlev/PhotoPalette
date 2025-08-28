//
//  HistoryViewModel.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI
import SwiftData

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var palettes: [ColorPalette] = []
    @Published var searchText = ""

    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchPalettes()
    }
    
    func fetchPalettes() {
        let descriptor = FetchDescriptor<ColorPalette>(
            sortBy: [SortDescriptor(\.creationDate, order: .reverse)]
        )
        
        do {
            palettes = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed: \(error)")
        }
    }
    
    func deletePalette(_ palette: ColorPalette) {
        modelContext.delete(palette)
        fetchPalettes() // Обновляем список
    }
    
    var filteredPalettes: [ColorPalette] {
        if searchText.isEmpty {
            return palettes
        } else {
            return palettes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
