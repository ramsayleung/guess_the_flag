//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by ramsayleung on 2023-12-23.
//

import SwiftUI

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "UK", "US", "Ukraine"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var score = 0
    @State private var previousScore = 0
    @State private var questionCounter = 0
    @State private var showingFinalJudge = false
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue, .red], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack{
                
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Spacer()
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of ")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                Spacer()
                Spacer()
                
                HStack{
                    Text("Your score is:")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("\(score)")
                        .font(.largeTitle.bold())
                        .foregroundColor(scoreChangeColor())
                        .onAppear {
                            previousScore = score
                        }
                        .onChange(of: score) { newScore in
                            withAnimation(.linear(duration: 3)) {
                                previousScore = newScore
                            }
                        }
                }
                Spacer()
                Text("Asked question number: \(questionCounter)")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }.alert(scoreTitle, isPresented: $showingScore){
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is: \(score)")
            }.alert("", isPresented: $showingFinalJudge){
                Button("Restart") {
                    reset()
                }
            }
        message: {
            Text("Your final score is: \(score)")
        }
            
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        }else{
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
        }
        questionCounter += 1
        print("questionCounter: \(questionCounter)")
        if(questionCounter >= 8){
            showingFinalJudge = true
        }else{
            showingScore = true
        }
    }
    
    private func scoreChangeColor() -> Color {
        return score > previousScore ? .green : (score < previousScore ? .red : .white)
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset(){
        askQuestion()
        questionCounter = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
