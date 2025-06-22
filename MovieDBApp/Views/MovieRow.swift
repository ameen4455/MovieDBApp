//
//  MovieRow.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 12) {
                
                RemoteImageView(url: movie.fullPosterURL)
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text(movie.releaseDate ?? "N/A")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Rating: \(movie.voteAverage, specifier: "%.1f")/10")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text(movie.overview)
                        .font(.body)
                        .lineLimit(3)
                        .padding(.top, 4)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
