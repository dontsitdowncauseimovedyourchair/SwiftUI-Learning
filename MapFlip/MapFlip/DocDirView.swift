//
//  DocDirView.swift
//  MapFlip
//
//  Created by Alejandro González on 17/04/26.
//

import SwiftUI

struct DocDirView : View {
    var body: some View {
        Button("Read and Write") {
            ReadWrite()
        }
    }
    
    func ReadWrite() {
        let data = Data("Test Message".utf8)
        let url = URL.documentsDirectory.appending(path: "message.txt")
        
        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
            
            let storedData = try String(contentsOf: url, encoding: .utf8)
            
            print(storedData)
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    DocDirView()
}
