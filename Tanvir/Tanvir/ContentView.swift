import SwiftUI

struct ContentView: View {
    @State private var fruitPosition = CGPoint(x: 200, y: 400)
    @State private var isFruitVisible = true
    @State private var isBomb = false
    @State private var score = 0
    @State private var gameOver = false
    @State private var isAnimating = false

    let timer = Timer.publish(every: 2.5, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                if gameOver {
                    // Game Over Screen
                    VStack {
                        Text("Game Over")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()

                        Text("Final Score: \(score)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()

                        Button(action: {
                            restartGame(in: geometry.size) // Pass geometry size to restartGame
                        }) {
                            Text("Restart")
                                .font(.title2)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                                .shadow(radius: 10)
                        }
                        .padding()
                    }
                } else {
                    // Score Display
                    VStack {
                        Text("Score: \(score)")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.top, 50)
                        Spacer()
                    }

                    // Fruit or Bomb
                    if isFruitVisible {
                        Group {
                            if isBomb {
                                // Display Bomb (black circle)
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 100, height: 100)
                            } else {
                                // Display Fruit (gradient circle)
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.red, Color.orange, Color.yellow]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                                    .frame(width: 100, height: 100)
                            }
                        }
                        .position(fruitPosition)
                        .onTapGesture {
                            if isBomb {
                                // Game Over if tapped on Bomb
                                endGame()
                            } else {
                                // Increase score if tapped on Fruit
                                score += 1
                                isFruitVisible = false
                            }
                        }
                        .animation(.easeInOut(duration: 0.3))
                    }
                }
            }
            .onReceive(timer) { _ in
                if !gameOver {
                    showNextFruit(in: geometry.size)
                }
            }
        }
    }

    // Function to show the next fruit or bomb
    func showNextFruit(in size: CGSize) {
        // Randomly decide if it's a fruit or bomb (20% chance of being a bomb)
//        isBomb = Bool.random() && Int.random(in: 0...4) == 0
        isBomb = Int.random(in: 0...2) == 0
        
        // Random position within screen bounds
        let randomX = CGFloat.random(in: 50...(size.width - 50))
        let randomY = CGFloat.random(in: 150...(size.height - 150))
        fruitPosition = CGPoint(x: randomX, y: randomY)
        
        isFruitVisible = true
        
        // Hide fruit after a short time
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if isFruitVisible {
                isFruitVisible = false
            }
        }
    }

    // Function to end the game
    func endGame() {
        gameOver = true
    }

    // Function to restart the game
    func restartGame(in size: CGSize) {
        score = 0
        gameOver = false
        showNextFruit(in: size) // Use the passed size from GeometryReader
    }
}

#Preview {
    ContentView()
}

