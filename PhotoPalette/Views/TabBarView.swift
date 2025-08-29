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
            GeneratorView()
                .tabItem {
                    Label("Generate", systemImage: "photo")
                }
                .environmentObject(appState.paletteGeneratorVM)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .environmentObject(appState.historyVM)
        }
        .preferredColorScheme(.dark)
    }
}
