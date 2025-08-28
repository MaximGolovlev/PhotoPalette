//
//  TabBarView.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI
import SwiftData

struct TabBarView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        TabView {
            Tab("Generate", systemImage: "photo") {
                GeneratorView()
                    .environmentObject(appState.paletteGeneratorVM)
            }
            
            Tab("History", systemImage: "clock") {
                HistoryView()
                    .environmentObject(appState.historyVM)
            }
        }
        .preferredColorScheme(.dark)
    }
}
