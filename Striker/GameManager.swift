//
//  GameManager.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/3/24.
//

import Foundation
struct Game: Codable {
    var totalHit: Int
    var damageTaken: Int
    var difficulty: Int
    var sound: Bool
    var currentScore: Int
    var currentHp: Int
    var paused: Bool
    var endGame: Bool
}
class GameManager: ObservableObject {
    @Published var game: Game?

    init() {
           loadGame()
        if game == nil {
                   initializeGame()
               }
       }
    func toggleSound() {
           if var currentGame = game {
               currentGame.sound.toggle()
               game = currentGame
               saveGame()
           }
       }
    func resetCurrenrScore() {
            guard var game = game else { return }
        game.currentScore = 0
        game.endGame = false
            self.game = game
            saveGame()
        }
    func updateCurrenrScore(score: Int) {
            guard var game = game else { return }
        game.currentScore = score
            self.game = game
            saveGame()
        }
    func updateCurrenrHp(HP: Int) {
            guard var game = game else { return }
        game.currentHp += HP
            self.game = game
            saveGame()
        }
    func updateTotal() {
            guard var game = game else { return }
        game.totalHit += 1
            self.game = game
            saveGame()
        }
    func damageTaken() {
            guard var game = game else { return }
        game.damageTaken += 1
            self.game = game
            saveGame()
        }
    func updatePause(isPaused: Bool) {
            guard var game = game else { return }
        game.paused = isPaused
            self.game = game
            saveGame()
        }
    private func saveGame() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(game) {
            UserDefaults.standard.set(encoded, forKey: "game")
        }
    }
    func endGame(isEnd: Bool) {
            guard var game = game else { return }
        game.endGame = isEnd
            self.game = game
            saveGame()
        }
    func setDifficulty(_ newDifficulty: Int) {
          if var currentGame = game {
              currentGame.difficulty = newDifficulty
              game = currentGame
              saveGame()
          }
      }
    func resetHP() {
            guard var currentGame = game else { return }
            
            switch currentGame.difficulty {
                case 0:
                    currentGame.currentHp = 100
                case 1:
                    currentGame.currentHp = 75
                case 2:
                    currentGame.currentHp = 50
                default:
                    break
            }
            game = currentGame
            saveGame()
        }
    func getPlayerLevel() -> String {
           guard let currentGame = game else { return "Unknown" }
           let totalPlanesHit = currentGame.totalHit

           switch totalPlanesHit {
               case 0..<10:
                   return "Beginner"
               case 11...50:
                   return "Starter"
               case 51...100:
                   return "Pro"
               default:
                   return "Striker"
           }
       }
    func loadGame() {
        if let data = UserDefaults.standard.data(forKey: "game") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Game.self, from: data) {
                game = decoded
            }
        }
    }
    private func initializeGame() {
        game = Game(totalHit: 0, damageTaken: 0, difficulty: 0, sound: true, currentScore: 0, currentHp: 100, paused: false, endGame: false)
        saveGame()
    }
}
