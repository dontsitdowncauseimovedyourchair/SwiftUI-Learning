//
//  RatingView.swift
//  BookWorm
//
//  Created by Alejandro González on 15/03/26.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating : Int
    
    var label = "";
    
    var offImage : Image?
    var onImage = Image(systemName: "star.fill")
    
    var onColor = Color.yellow
    var offColor = Color.gray
    
    var maximumRating = 5
    
    var body: some View {
        if (!label.isEmpty) {
            Text(label)
        }
        
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { index in
                Button {
                    rating = index
                } label: {
                    image(for: index)
                        .foregroundStyle(index > rating ? offColor : onColor)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    func image(for index: Int) -> Image {
        return index > rating ? offImage ?? Image(systemName: "star") : onImage
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
