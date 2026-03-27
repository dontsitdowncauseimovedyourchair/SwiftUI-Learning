//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alejandro González on 19/12/25.
//

import SwiftUI

struct FlagImage : View {
    let image: String
    var body: some View {
        Image(image)
            .shadow(radius: 10)
            .clipShape(.capsule)
    }
    
    init(_ image: String) {
        self.image = image
    }
}

struct JapanGradient : View {
    let center: UnitPoint
    
    var body: some View {
        RadialGradient(stops: [
            .init(color: .red, location: 0.3),
            .init(color: .white, location: 0.3),
            .init(color: Color(red: 0.9, green: 0.9, blue: 0.9), location: 1)
        ], center: center, startRadius: 260, endRadius: 270)
    }
    
    
}

struct ContentView: View {
    
    @State private var showingScore: Bool = false
    @State private var showingResults: Bool = false
    @State private var score: Int = 0
    @State private var clickedFlag: Int = -1
    @State private var round: Int = 0
    
    @State private var alertMessage: String = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer: Int = Int.random(in: 0...3)
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                JapanGradient(center: .top)
                JapanGradient(center: .bottom)
            }
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle .bold())
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                
                Spacer()
                
                VStack(spacing: 40) {
                    VStack {
                        Text("Select the flag for")
                            .font(.headline .weight(.medium))
                        Text("\(countries[correctAnswer])")
                            .font(.largeTitle .weight(.semibold))
                            .animation(.default, value: correctAnswer)
                    }
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                    
                    VStack(spacing: 30) {
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(for: number)
                            } label: {
                                FlagImage(countries[number])
                            }
                            .rotation3DEffect(.degrees(clickedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                            .opacity(clickedFlag == -1 || clickedFlag == number ? 1 : 0.25)
                            .scaleEffect(clickedFlag == -1 || clickedFlag == number ? 1 : 0.75)
                            .saturation(clickedFlag == -1 || clickedFlag == number ? 1 : 0)
                            .animation(.easeInOut, value: clickedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical,25)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title .bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(alertMessage, isPresented: $showingScore) {
            Button("Next") {
                updateGame()
            }
        } message: {
            Text(clickedFlag != correctAnswer ? "That's the \(countries[clickedFlag == -1 ? 0 : clickedFlag]) flag" : "")
        }
        .alert("Final score is: \(score)", isPresented: $showingResults) {
            Button("New Game") {
                resetGame()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            resetGame()
        }
    }
    
    func flagTapped(for number: Int) {
        
        clickedFlag = number
        
        if (number == correctAnswer) {
            score += 1
            alertMessage = "You're right!!!"
        } else {
            score -= 1
            alertMessage = "You're Mr. Flop"
        }
        round += 1
        
        showingScore = true
    }
    
    func updateGame() {
        if (round >= 8) {
            showingResults = true;
            return //I added this return to help the user feel the game reset after they clicked "New Game", which calls the resetGame function
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<3)
        
        clickedFlag = -1
    }
    
    func resetGame() {
        score = 0
        round = 0
        updateGame()
    }
}

#Preview {
    ContentView()
}
