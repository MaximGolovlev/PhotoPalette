//
//  PhotoPaletteApp.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//

import SwiftUI

@main
struct PhotoPaletteApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(appState)
                .environment(\.modelContext, appState.modelContext)
        }
        .modelContainer(appState.modelContainer)
    }
}
