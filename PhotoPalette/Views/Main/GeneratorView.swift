//
//  GeneratorView.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI
import PhotosUI
import SwiftData

struct GeneratorView: View {
    @EnvironmentObject private var viewModel: PaletteGeneratorViewModel
    @State private var showCancelConfirmation = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Image Picker
                    ZStack(alignment: .topTrailing) {
                        PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                            if let image = viewModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .cornerRadius(12)
                            } else {
                                ContentUnavailableView(
                                    "Select Photo",
                                    systemImage: "photo.on.rectangle",
                                    description: Text("Choose a photo from your library to generate a color palette")
                                )
                                .frame(height: 300)
                            }
                        }
                        .onChange(of: viewModel.selectedItem) { _, newItem in
                            Task {
                                await viewModel.loadImage()
                            }
                        }
                        
                        // Кнопка отмены (показываем только когда есть изображение)
                        if viewModel.selectedImage != nil {
                            Button {
                                showCancelConfirmation = true
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.6))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                        }
                    }
                    
                    // Processing Indicator
                    if viewModel.isProcessing {
                        ProgressView("Analyzing colors...")
                    }
                    
                    // Extracted Colors
                    if !viewModel.extractedColors.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Color Palette")
                                .font(.headline)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                                ForEach(viewModel.extractedColors) { appColor in
                                    ColorChipView(color: appColor.color, hex: appColor.hex)
                                }
                            }
                            
                            // Save Section
                            TextField("Palette Name", text: $viewModel.paletteName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button("Save Palette") {
                                viewModel.savePalette()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(viewModel.paletteName.isEmpty)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Photo Palette")
            .alert("Cancel Analysis", isPresented: $showCancelConfirmation) {
                Button("Keep", role: .cancel) { }
                Button("Leave", role: .destructive) {
                    viewModel.cancelImageSelection()
                }
            } message: {
                Text("Are you sure you want to leave? The current image and color analysis will be lost.")
            }
        }
        .environmentObject(viewModel)
    }
}
