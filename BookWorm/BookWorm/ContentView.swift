//
//  ContentView.swift
//  BookWorm
//
//  Created by Alejandro González on 31/01/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var isAddingView = false
    
    @Environment(\.modelContext) var modelContext;
    @Query(sort:
            [
                SortDescriptor(\Book.rating, order: .reverse),
                SortDescriptor(\Book.title)
            ]) var books : [Book]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.rating == 1 ? .red : .primary)
                                
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("BookFlop")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
            }
            .sheet(isPresented: $isAddingView) {
                AddBook()
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            modelContext.delete(books[offset])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self)
}
