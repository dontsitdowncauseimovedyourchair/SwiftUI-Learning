//
//  ShareLinkView.swift
//  InstaFilter
//
//  Created by Alejandro González on 12/04/26.
//

import SwiftUI
internal import System

struct ShareLinkView: View {
    var body: some View {
        ShareLink(item: URL(string:"www.papulandia.com")!, subject: Text("Hola"), message: Text("Message super pro")) {
            Label("Comparte para más papus", systemImage: "airplane")
        }
        
        ShareLink(item: Image(.example), subject: Text("Aeropuerto pro"), message: Text("Bendecida tarde"), preview: SharePreview("Sharing airport pro", image: Image(.example))) {
            Label("Comparte este super aeropuerto pro max", systemImage: "airplane")
        }
    }
}

#Preview {
    ShareLinkView()
}
