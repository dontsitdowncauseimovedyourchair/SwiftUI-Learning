//
//  ContentView.swift
//  Flop paper scissors
//
//  Created by Alejandro González on 23/12/25.
//

import SwiftUI

enum RockPaperScissors : String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
    
    var beats: RockPaperScissors {
        switch self {
        case .rock: return .scissors
        case .paper: return .rock
        case .scissors: return .paper
        }
    }
}

enum RoundResult {
    case win
    case lose
    case tie
}

struct SelectableImage : View {
    var image: String
    var action: (RockPaperScissors) -> Void
    var body: some View {
        Button {
            action(RockPaperScissors(rawValue: image)!)
        } label: {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 160)
                .background(.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 5, x: 2, y: 2)
        }
    }
    
    init(_ image: String, _ action: @escaping (RockPaperScissors) -> Void) {
        self.image = image
        self.action = action
    }
    
}

struct InfoText : View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .font(.title3)
            .shadow(radius: 10)
    }
    
    init(_ text: String){
        self.text = text
    }
}

struct ContentView: View {
    
    @State private var botPick = RockPaperScissors.allCases.randomElement() ?? .rock
    @State private var mission = Bool.random()
    @State private var score = 0
    @State private var round = 1
    @State private var showingDoneAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .white, .cyan.opacity(0.5)], startPoint: .top, endPoint: .bottom)
            VStack {
                Spacer()
                Spacer()
                
                Text("Flop Paper Scissors")
                    .font(.title .weight(.medium))
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                
                HStack(spacing: 50) {
                    InfoText("Score: \(score)")
                    InfoText("Round \(round)/10")
                }
                
                Spacer()
                
                VStack {
                    InfoText("Mission: \(mission ? "Win" : "Lose")")
                    
                    Image(botPick.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                .padding(20)
                .background(LinearGradient(stops: [
                    Gradient.Stop(color: .cyan, location: 0.1),
                    Gradient.Stop(color: .white, location: 0.8)
                ], startPoint: .top, endPoint: .bottom))
                .clipShape(.rect(cornerRadius: 10))
                .foregroundStyle(.white)
                
                Spacer()
                
                VStack {
                    InfoText("Choose your move")
                    HStack {
                        SelectableImage("Rock") { selection in
                            verdict(selection)
                        }
                        SelectableImage("Paper") { selection in
                            verdict(selection)
                        }
                        SelectableImage("Scissors") { selection in
                            verdict(selection)
                        }
                    }
                }
                .padding()
                .background(.white.opacity(0.5))
                .clipShape(.rect(cornerRadius: 10))
                
                
                Spacer()
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .alert("Finish!", isPresented: $showingDoneAlert) {
            Button("New Game") {
                score = 0
                round = 1
                randomPick()
            }
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    func verdict(_ selection: RockPaperScissors) {
        if selection == botPick {
            updateGame(result: .tie)
        } else if selection.beats == botPick {
            updateGame(result: .win)
        } else {
            updateGame(result: .lose)
        }
    }

    func updateGame(result: RoundResult) {
        switch result {
        case .win:
            score += mission ? 1 : -1
        case .lose:
            score += mission ? -1 : 1
        case .tie:
            score -= 1
        }
        
        round += 1
        if round > 10 {
            round = 10
            showingDoneAlert = true
        }
        
        randomPick()
    }
    
    func randomPick() {
        var newPick: RockPaperScissors
        var newMission: Bool
        
        repeat {
            newPick = RockPaperScissors.allCases.randomElement() ?? .rock
            newMission = Bool.random()
        } while(newPick == botPick && newMission == mission)
        
        botPick = newPick
        mission = newMission
    }
}

#Preview {
    ContentView()
}
