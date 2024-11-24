//
//  IntroView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 11/12/24.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        ZStack {
            Color.white
            Color.customGreen
            VStack {
                GifImageView("intro")
                    .frame(width:300, height: 200)
                Text("Second Helping")
                    .font(.custom("StudyClash", size: 52))
                    .foregroundStyle(.white)
            }
            
        }
    }
    init() {
        for familyName in UIFont.familyNames {
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("-- \(fontName)")
            }
        }
    }
}

#Preview {
    IntroView()
}
