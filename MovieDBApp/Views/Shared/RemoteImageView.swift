//
//  RemoteImageView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct RemoteImageView: View {
    let url: URL?
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        guard let url = url, image == nil else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let loadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = loadedImage
                }
            }
        }.resume()
    }
}

