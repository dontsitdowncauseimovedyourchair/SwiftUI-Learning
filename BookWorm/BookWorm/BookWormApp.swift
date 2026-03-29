//
//  BookWormApp.swift
//  BookWorm
//
//  Created by Alejandro González on 31/01/26.
//

import SwiftData
import SwiftUI

@main
struct BookWormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
