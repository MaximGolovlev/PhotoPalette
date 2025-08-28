//
//  HistoryView.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI
import SwiftData

struct HistoryView: View {
    @EnvironmentObject private var viewModel: HistoryViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.filteredPalettes.isEmpty {
                    ContentUnavailableView(
                        "No Palettes",
                        systemImage: "paintpalette",
                        description: Text("Your generated color palettes will appear here")
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredPalettes) { palette in
                            NavigationLink {
                                PaletteDetailView(palette: palette)
                            } label: {
                                PaletteRowView(palette: palette)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.deletePalette(palette)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search palettes")
            .navigationTitle("History")
        }
        .onAppear {
            viewModel.fetchPalettes()
        }
    }
}

struct PaletteRowView: View {
    let palette: ColorPalette
    
    var body: some View {
        HStack {
            if let thumbnailData = palette.thumbnail,
               let uiImage = UIImage(data: thumbnailData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    .clipped()
            }
            
            VStack(alignment: .leading) {
                Text(palette.name)
                    .font(.headline)
                Text(palette.creationDate, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 2) {
                ForEach(palette.hexColors.prefix(3), id: \.self) { hex in
                    if let color = UIColor(hex: hex) {
                        Rectangle()
                            .fill(Color(color))
                            .frame(width: 15, height: 30)
                    }
                }
            }
            .cornerRadius(4)
        }
    }
}
