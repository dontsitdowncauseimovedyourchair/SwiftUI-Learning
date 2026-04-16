//
//  ContentView.swift
//  InstaFilter
//
//  Created by Alejandro González on 08/04/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI
import StoreKit
import PhotosUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var pickerItem: PhotosPickerItem?
    @State private var inIntensity = 0.5
    @State private var inRadius = 0.5;
    @State private var currentFilter : CIFilter = CIFilter.crystallize()
    @State private var showingDialog = false
    
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    let context = CIContext()

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: pickerItem, loadImage)
                
                Spacer()
                
                if (processedImage != nil && currentFilter.inputKeys.contains(kCIInputRadiusKey) && currentFilter.inputKeys.contains(kCIInputIntensityKey)) {
                    HStack {
                        Text("Radius")
                        Slider(value: $inRadius)
                    }
                    .onChange(of: inRadius, applyProcessing)
                }
                HStack {
                    Text("Intensity")
                    Slider(value: $inIntensity)
                        .onChange(of: inIntensity, applyProcessing)
                        .disabled(processedImage == nil ? true : false)
                }
                
                HStack {
                    Button("Change filter") {
                        showingDialog = true
                    }
                    .disabled(processedImage == nil ? true : false)
                    .confirmationDialog("Change filter", isPresented: $showingDialog) {
                        Button("Crystallize") { changeFilter(CIFilter.crystallize()) }
                        Button("Edges") { changeFilter(CIFilter.edges()) }
                        Button("Gaussian Blur") { changeFilter(CIFilter.gaussianBlur()) }
                        Button("Pixellate") { changeFilter(CIFilter.pixellate()) }
                        Button("Sepia Tone") { changeFilter(CIFilter.sepiaTone()) }
                        Button("Unsharp Mask") { changeFilter(CIFilter.unsharpMask()) }
                        Button("Vignette") { changeFilter(CIFilter.vignette()) }
                        Button("Bloom") { changeFilter(CIFilter.bloom() )}
                        Button("Cancel", role: .cancel) { }
                    }
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Super Instafilter image", image: processedImage))
                    }
                }
                
            }
            .navigationTitle("Instafilter")
            .padding(.horizontal)
        }
        
    }
    
    func changeFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        if filterCount > 20 {
            requestReview()
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await pickerItem?.loadTransferable(type: Data.self) else {
                return }
            guard let inputImage = UIImage(data: imageData) else { return }

            let beginImage = CIImage(image: inputImage)

            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if (inputKeys.contains(kCIInputIntensityKey)) {
            if (currentFilter.name == "CIEdges") {
                currentFilter.setValue(inIntensity * 35, forKey: kCIInputIntensityKey)
            } else {
                currentFilter.setValue(inIntensity, forKey: kCIInputIntensityKey)
            }
        }
        
        if (inputKeys.contains(kCIInputScaleKey)) {
            currentFilter.setValue(inIntensity * 10, forKey: kCIInputScaleKey)
        }
        
        if (inputKeys.contains(kCIInputAmountKey)) {
            currentFilter.setValue(inIntensity, forKey: kCIInputAmountKey)
        }
        
        if (inputKeys.contains(kCIInputRadiusKey) && inputKeys.contains(kCIInputIntensityKey)) {
            currentFilter.setValue(inRadius * 200, forKey: kCIInputRadiusKey)
        } else if (inputKeys.contains(kCIInputRadiusKey)) {
            currentFilter.setValue(inIntensity * 200, forKey: kCIInputRadiusKey)
        }
        
        guard let recipe = currentFilter.outputImage else { return }
        
        guard let actualImg = context.createCGImage(recipe, from: recipe.extent) else { return }
        
        let uiImg = UIImage(cgImage: actualImg)
        
        processedImage = Image(uiImage: uiImg)
    }
}

#Preview {
    ContentView()
}
