//
//  ContentView.swift
//  Navigation
//
//  Created by Alejandro González on 20/01/26.
//

import SwiftUI

struct DetailView: View {
    let number: Int
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationLink("Goto Random Number", value: Int.random(in: 0..<1000))
            .navigationTitle("View \(number)")
            .toolbar {
                Button() {
                    path = NavigationPath()
                } label: {
                    Image(systemName: "house.fill")
                }
            }
    }
}

struct ContentView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            DetailView(number: 0, path: $path)
                .navigationDestination(for: Int.self) { int in
                    DetailView(number: int, path: $path)
            }
        }
    }
}

#Preview {
    ContentView()
}
