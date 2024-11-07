//
//  LoadingView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 11/7/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.lightGray)
            GifImageView("loading")
                .frame(width:300, height: 200)
        }
        .opacity(0.5)
    }
}


#Preview {
    LoadingView()
}
