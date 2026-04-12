//
//  UnavailableView.swift
//  InstaFilter
//
//  Created by Alejandro González on 11/04/26.
//

import SwiftUI

struct UnavailableView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No snippets", systemImage: "swift")
        } description: {
            Text("The content has officially flopped")
        } actions: {
            Button("Do crazy stuff") {
                
            }
            .buttonStyle(.glassProminent)
        }
    }
}

#Preview {
    UnavailableView()
}
