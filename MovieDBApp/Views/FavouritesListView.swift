//
//  FavouritesListView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct FavouritesListView: View {
    @StateObject private var viewModel = FavouritesViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if viewModel.favourites.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "heart.slash")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .foregroundColor(.gray)
                                .padding(.bottom, 8)
                            
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
                    } else {
                        ForEach(viewModel.favourites) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieRow(movie: movie)
                            }
                        }
                    }
                }.padding(.horizontal)
            }
            .navigationTitle("Favourites")
        }
        .onAppear {
            viewModel.loadFavourites()
        }
    }
}
