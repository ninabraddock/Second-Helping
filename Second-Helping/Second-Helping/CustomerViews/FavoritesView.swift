//
//  FavoritesView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Favorites View")
                    .font(.largeTitle)
                    .padding(.top)
                    .padding(.leading, 15)
                Spacer()
            }
            Spacer()
        }
        .background(.white)
    }
}

#Preview {
    FavoritesView()
}
