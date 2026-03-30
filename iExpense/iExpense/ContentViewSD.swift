
//
//  ContentViewSD.swift
//  iExpense
//
//  Created by Alejandro González on 09/01/26.
//

import SwiftUI
import SwiftData

@Model
class ExpenseItemSD {
    var id = UUID()
    var name: String
    var type: String
    var price: Double
    
    init(id: UUID = UUID(), name: String, type: String, price: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.price = price
    }
}

struct ContentViewSD: View {
    
    @Query var expenses : [ExpenseItemSD]
    @Environment(\.modelContext) var modelContext
    
    @State private var filters : [String] = ["Personal", "Business"]
    @State private var sort : Bool = true
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack {
            ExpensesView(typeFilters: filters, sortDesc: sort ? [SortDescriptor(\ExpenseItemSD.price, order: .reverse)] : [SortDescriptor(\ExpenseItemSD.name)])
                .navigationTitle("iExpense")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                            Picker("Filters", selection: $filters) {
                                Text("All")
                                    .tag(["Personal", "Business"])
                                Text("Personal")
                                    .tag(["Personal"])
                                Text("Business")
                                    .tag(["Business"])
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Sort", systemImage: "arrow.up.arrow.down") {
                            sort.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            AddViewSD()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.blue)
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentViewSD()
        .modelContainer(for: ExpenseItemSD.self)
}
