//
//  ContentView.swift
//  Animation
//
//  Created by Alejandro González on 28/12/25.
//

import SwiftUI

struct CornerRotateModifier : ViewModifier {
    let anchor: UnitPoint
    let amount: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(anchor: .topLeading, amount: -90), identity: CornerRotateModifier(anchor: .topLeading, amount: 0))
    }
}

struct ContentView: View {

    @State private var isShowingRed = false
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 300, height: 300)
                .clipShape(.rect(cornerRadius: 10))
                
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 300, height: 300)
                    .clipShape(.rect(cornerRadius: 10))
                    .transition(.pivot)
                    .zIndex(1)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
