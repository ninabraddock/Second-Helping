//
//  StatsView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 9/25/24.
//

import SwiftUI
import WebKit

let theme_color = Color("main_color_theme")

struct GifImageView: UIViewRepresentable {
    private let name: String
    init(_ name: String) {
        self.name = name
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
            do {
                let data = try Data(contentsOf: url)
                webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
            } catch {
                print("Error loading GIF: \(error)")
            }
        }
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.reload()
    }
}


struct StatsView: View {
    var body: some View {
        VStack {
            Text("Stats!")
                .font(.largeTitle)
            
            Spacer()
            
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    StatBox(text: "Food Saved", gifName: "food_saved", value: "20", subtitle: "pounds")
                    StatBox(text: "CO₂ Avoided", gifName: "CO2", value: "20", subtitle: "ppm")
                }
                
                HStack(spacing: 20) {
                    StatBox(text: "Money Saved", gifName: "money_gif", value: "$20", subtitle: "Dollars")
                    StatBox(text: "Meals Saved", gifName: "meal_saved", value: "20", subtitle: "total")
                }
            }
            Spacer()
        }
        .padding()
    }
}

struct StatBox: View {
    let text: String
    let gifName: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
//                .padding(.top, 10)
//            Spacer()
            
            GifImageView(gifName)
                .frame(width: 100, height: 75)
            
            // TODO:
            Text(value)
                .font(.title3)
                .bold()
            
//            Spacer()
            
            Text(subtitle)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
//            Spacer()
            
        }
        .padding()
//        .background(Color.green)
//        .foregroundColor(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(theme_color, lineWidth: 3)
        )
    }
}

#Preview {
    StatsView()
}
