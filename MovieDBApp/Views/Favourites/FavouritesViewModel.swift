//
//  FavouritesViewModel.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

final class FavouritesViewModel: ObservableObject {
    @Published var favourites: [Movie] = []
    @Published var selectedMovie: Movie?
    @Published var showFavouriteMovie = false
    
    let favouriteManager: FavouriteManager

    init(favouriteManager: FavouriteManager) {
        self.favouriteManager = favouriteManager
    }

    func loadFavourites() {
        favourites = favouriteManager.favourites
    }
}
