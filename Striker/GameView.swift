//
//  GameView.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/3/24.
//

import SwiftUI
import SpriteKit

struct GameMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameManager: GameManager
    @State private var isEnd = false
    var isPaused = false
    var body: some View {
        ZStack{
            BackgroundView()
            VStack{
                if isEnd == false {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: 120 * sizeScreen())
                        .foregroundColor(Color("orangeOne"))
                        .overlay(
                            VStack{
                                Spacer()
                                HStack{
                                    Text("HP: \(gameManager.game!.currentHp)")
                                        .foregroundColor(.white)
                                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                                        .frame(width: 75 * sizeScreen())
                                    Spacer()
                                    Image("backButton")
                                        .resizable()
                                        .frame(width: 50 * sizeScreen(), height: 50 * sizeScreen())
                                        .onTapGesture {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    Spacer()
                                    Text("PTS: \(gameManager.game!.currentScore)")
                                        .foregroundColor(.white)
                                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                                        .frame(width: 75 * sizeScreen())
                                }
                                .padding()
                            }
                            
                        )
                    
                    Spacer()
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        SKViewContainer(scene: GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 150 * sizeScreen()), gameManager: gameManager))
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 150 * sizeScreen())
                            .padding(.bottom, 50 * sizeScreen())
                            .onAppear{
                                gameManager.resetHP()
                                gameManager.resetCurrenrScore()
                            }
                    }else{
                        SKViewContainer(scene: GameScene(size: CGSize(width: 390 * sizeScreen(), height: 680 * sizeScreen()), gameManager: gameManager))
                            .frame(width: 390 * sizeScreen(), height: 680 * sizeScreen())
                            .padding(.bottom, 50 * sizeScreen())
                            .onAppear{
                                gameManager.resetHP()
                                gameManager.resetCurrenrScore()
                            }
                    }
                }
                let endGameResult = gameManager.game?.endGame
                if endGameResult == true {
                    EndOverlayView(gameManager: gameManager, isEnd: $isEnd)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear{
            if gameManager.game!.sound {
                SoundManager.shared.playBackgroundMusic()
           }
        }
        .onDisappear{
            SoundManager.shared.stopBackgroundMusic()
        }
    }
}

struct EndOverlayView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gameManager: GameManager
    @Binding var isEnd: Bool
    var body: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Text("End")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 25 * sizeScreen()))
                    Text("Score: \(gameManager.game?.currentScore ?? 0)")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 25 * sizeScreen()))
                        .padding()

                    RoundedRectangle(cornerRadius: 15 * sizeScreen())
                        .frame(width: 249 * sizeScreen(), height: 50 * sizeScreen())
                        .foregroundColor(Color("orangeOne"))
                        .overlay(
                        Text("Restart")
                            .foregroundColor(.white)
                            .font(.custom("IrishGrover-Regular", size: 25 * sizeScreen()))
                            
                        )
                        .onTapGesture {
                            isEnd = false
                            gameManager.resetCurrenrScore()
                            gameManager.endGame(isEnd: false)
                            }
                        .padding()
                    RoundedRectangle(cornerRadius: 15 * sizeScreen())
                        .frame(width: 249 * sizeScreen(), height: 50 * sizeScreen())
                        .foregroundColor(Color("orangeOne"))
                        .overlay(
                        Text("Exit to menu")
                            .foregroundColor(.white)
                            .font(.custom("IrishGrover-Regular", size: 25 * sizeScreen()))
                            
                        )
                        .padding(.bottom, 70 * sizeScreen())
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                    .padding()
                
            )
            .onAppear{
                isEnd = true
            }
           
    }
    
}

struct SKViewContainer: UIViewRepresentable {
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        let skView = SKView()
        skView.backgroundColor = .clear
        skView.presentScene(scene)
        skView.isUserInteractionEnabled = true
        return skView
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        
    }
}

