//
//  Untitled.swift
//  Second-Helping
//
//  Created by Nina Braddock on 11/27/24.
//
import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @Binding var data: Data?
    @State private var selectedItems: [PhotosPickerItem] = []

    var body: some View {
        VStack {
            if let data = data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }

            PhotosPicker(selection: $selectedItems, matching: .images) {
                Text("Pick Photo")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .onChange(of: selectedItems) { _ in
                Task {
                    if let firstItem = selectedItems.first {
                        do {
                            data = try await firstItem.loadTransferable(type: Data.self)
                        } catch {
                            print("Error loading image: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
}
