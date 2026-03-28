//
//  AddView.swift
//  iExpense
//
//  Created by Alejandro González on 09/01/26.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var price: Double?
    
    var expenses: Expenses
    
    let types = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense name", text: $name)
                
                Picker("Type of expense", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text("\($0)")
                    }
                }
                HStack {
                    Text("$")
                    TextField("0.00", value: $price, format: .currency(code: Locale.current.currency?.identifier ?? "MXN"))
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add expense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.red)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if (name.isEmpty || price == nil) {
                            return
                        }
                        
                        expenses.items.append(ExpenseItem(name: name, type: type, price: price ?? 0))
                        dismiss()
                    }
                    .tint(.blue)
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
