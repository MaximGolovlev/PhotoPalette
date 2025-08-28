//
//  PaletteDetailView.swift
//  PhotoPalette
//
//  Created by Maxim Golovlev on 28.08.2025.
//


import SwiftUI
import SwiftData

struct PaletteDetailView: View {
    let palette: ColorPalette
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    @State private var copiedColorIndex: Int?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: HistoryViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Thumbnail Image
                if let thumbnailData = palette.thumbnail,
                   let uiImage = UIImage(data: thumbnailData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                
                // Palette Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(palette.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Created \(palette.creationDate, format: .dateTime.day().month().year())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Color Grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(Array(palette.colors.enumerated()), id: \.element.id) { index, appColor in
                        DetailedColorChipView(
                            color: appColor,
                            isCopied: copiedColorIndex == index
                        )
                    }
                }
                
                // Export Options
                VStack(spacing: 12) {
                    Text("Export Options")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                        copyAllColors()
                    }) {
                        Label("Copy All HEX Codes", systemImage: "doc.on.doc")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Label("Share Palette", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Palette Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .alert("Delete Palette", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deletePalette()
            }
        } message: {
            Text("Are you sure you want to delete \"\(palette.name)\"? This action cannot be undone.")
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [generateShareText()])
        }
    }
    
    private func copyAllColors() {
        let allHexCodes = palette.colors.map { $0.hex }.joined(separator: "\n")
        UIPasteboard.general.string = allHexCodes
        
        // Show some feedback (could use a toast in real implementation)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func generateShareText() -> String {
        let header = "Color Palette: \(palette.name)\n\n"
        let colorsText = palette.colors.map { color in
            "\(color.hex) - \(color.rgb)"
        }.joined(separator: "\n")
        
        return header + colorsText
    }
    
    private func deletePalette() {
        viewModel.deletePalette(palette)
        dismiss()
    }
}

// Detailed Color Chip View
struct DetailedColorChipView: View {
    let color: AppColor
    @State var isCopied: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Color Square
            RoundedRectangle(cornerRadius: 12)
                .fill(color.color)
                .frame(height: 100)
            
            // Color Information
            VStack(spacing: 4) {
                Text(color.hex)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.medium)
                
                Text(color.rgb)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.clear, lineWidth: 2)
        )
        .animation(.spring(response: 0.3), value: isCopied)
        .alert("Copied!", isPresented: $isCopied) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("HEX code \(color.hex) copied to clipboard")
        }
        .onTapGesture {
            isCopied = true
            UIPasteboard.general.string = color.hex
        }
    }
}

// Share Sheet Wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Preview
#Preview {
    let mockPalette = ColorPalette(
        name: "Sunset Beach",
        hexColors: ["#FF6B6B", "#4ECDC4", "#45B7D1", "#F9A826", "#6C5CE7"]
    )
    
    return NavigationView {
        PaletteDetailView(palette: mockPalette)
    }
}
