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
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        if let date = viewModel.movie.releaseDate {
                            Text("RELEASE DATE")
                                .font(.system(size: 12))
                                .foregroundColor(Color.primary.opacity(0.4))
                                .multilineTextAlignment(.leading)
                            
                            Text("\(date)")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color.primary.opacity(0.6))
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    Spacer()
                    
                    RatingBadge(rating: viewModel.movie.voteAverage)
                }

                Text(viewModel.movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
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
