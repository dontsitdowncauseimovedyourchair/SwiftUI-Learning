//
//  ContentView.swift
//  BetterSleep
//
//  Created by Alejandro González on 26/12/25.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var pickedTime = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeIntake = 2
    
    @State private var modelPredictionDate: Date = .now

    static var defaultWakeTime: Date {
        let nowPlus8Hours = Calendar.current.date(byAdding: .hour, value: 8, to: .now) ?? .now
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: nowPlus8Hours)
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        
        NavigationStack {
            Form() {
                Section {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("When do you want to wake up?")
                            .font(.headline)
                        DatePicker("Enter a time", selection: $pickedTime, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Desired amount of sleep")
                            .font(.headline)
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Daily Coffe Intake")
                            .font(.headline)
                        Stepper("^[\(coffeeIntake) cup](inflect: true)", value: $coffeeIntake, in: 0...100)
                    }
                } header: {
                    Text("Rest Data")
                }
                
                Section() {
                    Text("Ideal bedtime is at \(modelPredictionDate.formatted(date: .omitted, time: .shortened))")
                } header: {
                    Text("Your BetterRest")
                }
            }
            .navigationTitle("BetterRest")
            .onChange(of: pickedTime) {
                calculateBedTime()
            }
            .onChange(of: sleepAmount) {
                calculateBedTime()
            }
            .onChange(of: coffeeIntake) {
                calculateBedTime()
            }
            .onAppear() {
                calculateBedTime()
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
         
            let components = Calendar.current.dateComponents([.hour, .minute], from: pickedTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeIntake))
            
            let bedTime = pickedTime - prediction.actualSleep
            
            modelPredictionDate = bedTime
            
        } catch {
            modelPredictionDate = Calendar.current.date(from: DateComponents()) ?? .now
        }
    }
}

#Preview {
    ContentView()
}
