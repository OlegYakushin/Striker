//
//  LevelsOverlayView.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/4/24.
//

import SwiftUI

struct LevelsOverlayView: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                Spacer()
                VStack(spacing: 20 * sizeScreen()){
                    Text("How Mastery Level is calculated:")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("BEGINNER")
                        .foregroundColor(Color("orangeOne"))
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("Total planes hit: under 10")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("STARTER")
                        .foregroundColor(Color("orangeOne"))
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("Total planes hit: in 11-50")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("PRO")
                        .foregroundColor(Color("orangeOne"))
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("Total planes hit: in 51-100")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("STRIKER")
                        .foregroundColor(Color("orangeOne"))
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                    Text("Total planes hit: 101 or more")
                        .foregroundColor(.white)
                        .font(.custom("IrishGrover-Regular", size: 20 * sizeScreen()))
                }
                .frame(width: 390 * sizeScreen(), height: 400 * sizeScreen())
                .background(Color("grayOne"))
            }
        }
    }
}

#Preview {
    LevelsOverlayView()
}
