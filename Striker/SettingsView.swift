 //
//  SettingsView.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/3/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("difficultyIndex") var difficultyIndex = 0
    var gameManager: GameManager
    let difficulties = ["beginner", "pilot", "striker"]
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                HStack {
                    Image("enemyTwo")
                        .resizable()
                        .frame(width: 51 * sizeScreen(), height: 51 * sizeScreen())
                        .rotationEffect(.degrees(90))
                    Text("settings")
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 35 * sizeScreen()))
                    Image("enemyTwo")
                        .resizable()
                        .frame(width: 51 * sizeScreen(), height: 51 * sizeScreen())
                        .rotationEffect(.degrees(-90))
                }
                Image("playerShipImage")
                    .resizable()
                    .frame(width: 156 * sizeScreen(), height: 156 * sizeScreen())
                VStack(spacing: 20) {
                    ButtonView(text: "SOUND: \(gameManager.game!.sound ? "ON" : "OFF")")
                        .onTapGesture {
                            gameManager.toggleSound()
                        }
                    ButtonView(text: "DIFFICULTY: \(difficulties[difficultyIndex])")
                        .onTapGesture {
                            difficultyIndex = (difficultyIndex + 1) % difficulties.count
                            gameManager.setDifficulty(difficultyIndex)
                        }
                }
                Spacer()
                SmallButtonView(text: "to menu")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .padding(40 * sizeScreen())
        }
    }
}
