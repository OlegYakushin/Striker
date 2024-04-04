//
//  MainView.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/3/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var game = GameManager()
    var body: some View {
        NavigationView{
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        Image("enemyTwo")
                            .resizable()
                            .frame(width: 51 * sizeScreen(), height: 51 * sizeScreen())
                            .rotationEffect(.degrees(90 * sizeScreen()))
                        Text("STRIKER")
                            .foregroundColor(.white)
                            .font(.custom("IrishGrover-Regular", size: 35 * sizeScreen()))
                        Image("enemyTwo")
                            .resizable()
                            .frame(width: 51 * sizeScreen(), height: 51 * sizeScreen())
                            .rotationEffect(.degrees(-90))
                    }
                    Spacer()
                    Text("WELCOME, PLAYER!")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 25 * sizeScreen()))
                        .padding(.bottom, 50 * sizeScreen())
                    Image("playerShipImage")
                        .resizable()
                        .frame(width: 156 * sizeScreen(), height: 156 * sizeScreen())
                    Spacer()
                    VStack(spacing: 20 * sizeScreen()) {
                        NavigationLink(destination: GameMainView(gameManager: game).navigationBarBackButtonHidden()) {
                            SmallButtonView(text: "play")
                        }
                        NavigationLink(destination: MyCareerView(gameManager: game).navigationBarBackButtonHidden()) {
                            SmallButtonView(text: "My Career")
                        }
                        NavigationLink(destination: SettingsView(gameManager: game).navigationBarBackButtonHidden()) {
                            SmallButtonView(text: "game settings")
                        }
                    }
                }
                .padding(50 * sizeScreen())
            }
            .onAppear{
                game.loadGame()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear{
            game.resetHP()
            game.resetCurrenrScore()
        }
    }
}

struct ButtonView: View {
    var text: String
    var body: some View {
        RoundedRectangle(cornerRadius: 15 * sizeScreen())
            .frame(width: 335 * sizeScreen(), height: 81 * sizeScreen())
            .foregroundColor(Color("orangeOne"))
            .overlay(
                Text(text)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .font(.custom("IrishGrover-Regular", size: 25 * sizeScreen()))
            )
    }
    
    }
struct SmallButtonView: View {
    var text: String
    var body: some View {
        RoundedRectangle(cornerRadius: 15 * sizeScreen())
            .frame(width: 296 * sizeScreen(), height: 73 * sizeScreen())
            .foregroundColor(Color("orangeOne"))
            .overlay(
                Text(text)
                    .textCase(.uppercase)
                    .foregroundColor(.white)
                    .font(.custom("IrishGrover-Regular", size: 25 * sizeScreen()))
            )
    }
    
    }

#Preview {
    MainView()
}
