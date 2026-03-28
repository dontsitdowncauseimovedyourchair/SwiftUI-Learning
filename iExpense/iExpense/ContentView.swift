//
//  ContentView.swift
//  iExpense
//
//  Created by Alejandro González on 09/01/26.
//

import SwiftUI

struct ExpenseItem : Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: String
    let price: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let data = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(data, forKey: "expenses")
            }
        }
    }
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "expenses") {
            if let data = try? JSONDecoder().decode([ExpenseItem].self, from: savedData) {
                items = data
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    
    @State private var expenses = Expenses()
    
    @State private var showingAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                if (expenses.items.contains { item in
                    item.type == "Personal"
                }) {
                    Section("Personal") {
                        ForEach(expenses.items) { item in
                            if (item.type == "Personal") {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.name)")
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "MXN"))
                                        .foregroundStyle(item.price < 10 ? .green : item.price < 100 ? .orange : .red)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                if (expenses.items.contains { item in
                    item.type == "Business"
                }) {
                    Section("Business") {
                        ForEach(expenses.items) { item in
                            if (item.type == "Business") {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(item.name)")
                                    }
                                    
                                    Spacer()
                                    
                                    Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "MXN"))
                                        .foregroundStyle(item.price < 10 ? .green : item.price < 100 ? .orange : .red)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expenses: expenses)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
