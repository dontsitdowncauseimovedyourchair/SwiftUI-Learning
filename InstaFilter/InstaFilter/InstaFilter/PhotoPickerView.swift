//
//  PhotoPickerView.swift
//  InstaFilter
//
//  Created by Alejandro González on 11/04/26.
//

import PhotosUI
import SwiftUI

struct PhotoPickerView: View {
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedPhotos = [Image]()
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
                Label("Select epic photo", systemImage: "photo")
            }
            
            ScrollView {
                ForEach(0..<selectedPhotos.count, id: \.self) { i in
                    selectedPhotos[i]
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .onChange(of: pickerItems) {
            Task {
                selectedPhotos.removeAll()
                
                for pickerItem in pickerItems {
                    if let photo = try await pickerItem.loadTransferable(type: Image.self) {
                        selectedPhotos.append(photo)
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView()
}
