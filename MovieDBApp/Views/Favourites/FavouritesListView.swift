//
//  FavouritesListView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct FavouritesListView: View {
    @StateObject private var viewModel: FavouritesViewModel

    init(manager: FavouriteManagerProtocol) {
        _viewModel = StateObject(wrappedValue: FavouritesViewModel(favouriteManager: manager))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.favourites.isEmpty {
                        emptyStateView
                    } else {
                        movieGrid
                    }
                    
                    // Hidden NavigationLink for programmatic navigation
                    NavigationLink(
                        destination: detailDestination,
                        isActive: $viewModel.showFavouriteMovie
                    ) {
                        EmptyView()
                    }
                    .hidden()
                    
                   
                }.padding(.horizontal)
            }
            .onAppear {
                viewModel.loadFavourites()
            }
            .navigationTitle("Favourites")
        }
    }
    
    @ViewBuilder
    private var detailDestination: some View {
        if let movie = viewModel.selectedMovie {
            MovieDetailView(movie: movie, favouritesManager: viewModel.favouriteManager)
        } else {
            EmptyView()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Image(systemName: "heart.slash")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(.gray)
                .padding(.vertical)

            Text("No favourites yet")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Mark movies as favourites to see them here.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var movieGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(viewModel.favourites) { movie in
                Button {
                    viewModel.selectedMovie = movie
                    viewModel.showFavouriteMovie = true
                } label: {
                    MovieRow(movie: movie)
                }
            }
        }
        .padding(.top)
    }
}
