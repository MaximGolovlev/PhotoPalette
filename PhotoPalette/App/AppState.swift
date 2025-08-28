//
//  AppState.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//

import SwiftUI
import SwiftData

@MainActor
class AppState: ObservableObject {
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    // ViewModels
    let paletteGeneratorVM: PaletteGeneratorViewModel
    let historyVM: HistoryViewModel
    
    init() {
        // Инициализируем SwiftData container
        let schema = Schema([ColorPalette.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = ModelContext(modelContainer)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
        // Инициализируем ViewModels с правильным context
        paletteGeneratorVM = PaletteGeneratorViewModel(modelContext: modelContext)
        historyVM = HistoryViewModel(modelContext: modelContext)
    }
}
