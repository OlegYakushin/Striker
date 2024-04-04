//
//  MyCareerView.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/3/24.
//

import SwiftUI

struct MyCareerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showOverlay = false
    var gameManager: GameManager
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Image("enemyTwo")
                        .resizable()
                        .frame(width: 51 * sizeScreen(), height: 51 * sizeScreen())
                        .rotationEffect(.degrees(90))
                    Text("MY CAREER")
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
                VStack(spacing: 20 * sizeScreen()) {
                    ButtonView(text: "TOTAL PLANES HIT: \(gameManager.game?.totalHit ?? 0)")
                    ButtonView(text: "DAMAGE TAKEN: \(gameManager.game?.damageTaken ?? 0)")
                    ButtonView(text: "MASTERY LEVEL: \(gameManager.getPlayerLevel())")
                        .onTapGesture {
                            withAnimation {
                                showOverlay.toggle()
                            }
                        }
                }
                Spacer()
                SmallButtonView(text: "to menu")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .padding(40 * sizeScreen())
            if showOverlay {
                LevelsOverlayView()
                    .onTapGesture {
                        withAnimation {
                            showOverlay.toggle()
                        }
                    }
            }
        }
    }
}
