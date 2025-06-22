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
            RemoteImageView(url: movie.fullPosterURL)
                .aspectRatio(2/3, contentMode: .fill)
                .cornerRadius(8)
            
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
