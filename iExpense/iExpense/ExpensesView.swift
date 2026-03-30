//
//  ExpensesView.swift
//  iExpense
//
//  Created by Alejandro González on 29/03/26.
//

import SwiftData
import SwiftUI

struct ExpensesView: View {
    
    @Query var expenses : [ExpenseItemSD]
    @Environment(\.modelContext) var modelContext
    let selectedTypes : [String]
    
    //My O(n) approach to grouping by type
    var expenseGroups : [String: [ExpenseItemSD]] {
        Dictionary(grouping: expenses, by: \.type)
    }
    
    var body: some View {
        List {
            ForEach(selectedTypes, id: \.self) { type in
                if let itemsForType = expenseGroups[type], !itemsForType.isEmpty {
                    Section(type) {
                        ForEach(itemsForType) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(item.name)")
                                }
                                
                                Spacer()
                                
                                Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "MXN"))
                                    .foregroundStyle(item.price < 10 ? .green : item.price < 100 ? .orange : .red)
                            }
                        }
                        .onDelete { offsets in
                            deleteItems(at: offsets, in: itemsForType)
                        }
                    }
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet, in items: [ExpenseItemSD]) {
        for offset in offsets {
            modelContext.delete(items[offset])
        }
    }
    
    init(typeFilters: [String], sortDesc: [SortDescriptor<ExpenseItemSD>]) {
        _expenses = Query(filter: #Predicate { expenseItem in
            typeFilters.contains(expenseItem.type)
        }, sort: sortDesc)
        selectedTypes = typeFilters
    }
}

#Preview {
    ExpensesView(typeFilters: ["Personal"], sortDesc: [SortDescriptor(\ExpenseItemSD.price)])
        .modelContainer(for: ExpenseItemSD.self)
}
