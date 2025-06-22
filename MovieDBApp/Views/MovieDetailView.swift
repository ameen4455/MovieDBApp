//
//  MovieDetailView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    init(movie: Movie, favouritesManager: FavouriteManagerProtocol) {
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movie: movie, manager: favouritesManager))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = viewModel.movie.fullBackDropURL {
                    RemoteImageView(url: url)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(8)
                        .clipped()
                } else if let url = viewModel.movie.fullPosterURL {
                    RemoteImageView(url: url)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(8)
                        .clipped()
                }

                Text(viewModel.movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(viewModel.movie.overview)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("Release Date: \(viewModel.movie.releaseDate ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Rating: \(viewModel.movie.voteAverage, specifier: "%.1f") / 10")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavourite()
                }) {
                    Image(systemName: viewModel.isFavourite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavourite ? .red : .primary)
                }
                .accessibilityIdentifier("favourite_button")
            }
        }
        .onAppear {
            viewModel.refreshFavouriteStatus()
        }
    }
}
