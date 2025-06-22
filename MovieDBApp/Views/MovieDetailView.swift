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
                if let url = viewModel.movie.fullPosterURL {
                    RemoteImageView(url: url)
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                }

                Text(viewModel.movie.title)
                    .font(.title)
                    .fontWeight(.bold)

                Text("Release Date: \(viewModel.movie.releaseDate ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Rating: \(viewModel.movie.voteAverage, specifier: "%.1f") / 10")
                    .font(.subheadline)
                    .foregroundColor(.orange)

                Text(viewModel.movie.overview)
                    .font(.body)
                    .multilineTextAlignment(.leading)
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

class MovieDetailViewModel: ObservableObject {
    @Published var isFavourite: Bool = false
    private let manager: FavouriteManagerProtocol

    let movie: Movie

    init(movie: Movie, manager: FavouriteManagerProtocol = FavouriteManager()) {
        self.movie = movie
        self.manager = manager
        self.isFavourite = manager.isFavourite(movie)
    }

    func toggleFavourite() {
        manager.toggleFavourite(movie)
        isFavourite = manager.isFavourite(movie)
    }
    
    func refreshFavouriteStatus() {
        isFavourite = manager.isFavourite(movie)
    }
}
