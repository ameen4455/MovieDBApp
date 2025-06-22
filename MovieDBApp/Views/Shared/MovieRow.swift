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
            RemoteImageView(url: movie.fullPosterURL, aspectRatio: 3/10)
                .cornerRadius(8)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                RatingBadge(rating: movie.voteAverage)
            }
        }
    }
}


struct RatingBadge: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star")
                .foregroundColor(Color.primary.opacity(0.7))
                .font(.system(size: 11, weight: .semibold))

            Text(String(format: "%.1f", rating))
                .foregroundColor(Color.primary.opacity(0.7))
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.primary.opacity(0.2))
        .cornerRadius(4)
    }
}
