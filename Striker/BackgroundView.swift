//
//  BackgroundView.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/3/24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("backgroundImage")
            .resizable()
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
