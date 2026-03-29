//
//  BookDetailView.swift
//  BookWorm
//
//  Created by Alejandro González on 16/03/26.
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
    let book : Book
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var lastReadFormatted : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: book.date)
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .foregroundStyle(.white)
                    .offset(x: -5, y: -5)
            }
            Text(book.author)
                .font(.title)
                .foregroundStyle(.secondary)
            
            Text("Last read: \(lastReadFormatted)")
                .padding(.vertical, 10)
            
            Text(book.review)
                .padding()
            
            //.constant makes the rating unchangeable
            RatingView(rating: .constant(book.rating))
                .font(.largeTitle)
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete book?", isPresented: $showingDeleteAlert) {
            Button("Keep", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteBook()
            }
        } message: {
            Text("Are you sure you want to delete \(book.title)")
        }
        

        Spacer()
        
        Button("Delete Book") {
            showingDeleteAlert.toggle()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.gray.opacity(0.25))
        .clipShape(.rect(cornerRadius: 10))
        .foregroundStyle(.red)
    }
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "This was a great book; I really enjoyed it.", rating: 4, date: Date.now)
        
        return BookDetailView(book: example)
        
            .modelContainer(container)
    } catch {
        return Text("Flop: \(error.localizedDescription)")
    }
}
