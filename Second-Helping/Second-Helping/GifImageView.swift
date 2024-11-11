//
//  GifImageView.swift
//  Second-Helping
//
//  Created by Nathan Blanchard on 11/7/24.
//

//import SwiftUI
//import WebKit
//
//struct GifImageView: UIViewRepresentable {
//    private let name: String
//    init(_ name: String) {
//        self.name = name
//    }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let webview = WKWebView()
//        if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
//            do {
//                let data = try Data(contentsOf: url)
//                webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
//            } catch {
//                print("Error loading GIF: \(error)")
//            }
//        }
//        return webview
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        uiView.reload()
//    }
//}
//#Preview {
//    GifImageView("loading.gif")
//}

import SwiftUI
import UIKit

struct GifImageView: UIViewRepresentable {
    private let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let path = Bundle.main.path(forResource: name, ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            imageView.image = UIImage.animatedImage(with: getGifFrames(data: data), duration: 2.0)
        }
        
        containerView.addSubview(imageView)
        
        // Constrain the imageView to the containerView's edges to scale properly with the frame
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No need to reload the view for updates as the GIF will loop automatically
    }
    
    // Helper function to extract frames from GIF data
    private func getGifFrames(data: Data) -> [UIImage] {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return [] }
        var images: [UIImage] = []
        
        for index in 0..<CGImageSourceGetCount(source) {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
        
        return images
    }
}

struct GifImageView_Preview: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            GifImageView("loading")
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

