//
//  AddBook.swift
//  BookWorm
//
//  Created by Alejandro González on 05/03/26.
//

import SwiftData
import SwiftUI

struct AddBook: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var review = ""
    @State private var rating = 3
    @State private var dateRead = Date.now
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Book Info") {
                    TextField("Name of the book", text: $title)
                    TextField("Author", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section {
                    DatePicker("Last Read", selection: $dateRead, in: ...Date.now, displayedComponents: .date)
                }
                
                Section {
                    Button("Save") {
                        saveBook()
                    }
                }
                
            }
            .navigationTitle("Add Book")
        }
    }
    
    func saveBook() {
        if (title.isEmpty || author.isEmpty) {
            return
        }
        
        let book = Book(title: title, author: author, genre: genre, review: review, rating: rating, date: dateRead)
        
        modelContext.insert(book)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddBook()
    }
}

