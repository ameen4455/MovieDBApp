//
//  MovieDetailViewModel.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 22/06/25.
//

import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var isFavourite: Bool = false
    private let manager: FavouriteManager

    let movie: Movie

    init(movie: Movie, manager: FavouriteManager) {
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
