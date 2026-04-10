//
//  ContentView.swift
//  InstaFilter
//
//  Created by Alejandro González on 08/04/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }

    func loadImage() {
        image = Image(.example)
        
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        let currentFilter = CIFilter.pixellate()
        
        currentFilter.inputImage = beginImage
        currentFilter.scale = 30
        
        guard let filteredRecipe : CIImage = currentFilter.outputImage else { return }
        
        guard let actualImage : CGImage = context.createCGImage(filteredRecipe, from: filteredRecipe.extent) else { return }
        
        let UIimg = UIImage(cgImage: actualImage)
        
        image = Image(uiImage: UIimg)
    }
}

#Preview {
    ContentView()
}
