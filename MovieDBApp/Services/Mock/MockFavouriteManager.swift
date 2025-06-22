//
//  MockFavouriteManager.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 22/06/25.
//

final class MockFavouriteManager: FavouriteManagerProtocol {
    static let shared = MockFavouriteManager()
    private init() {}

    private var favouriteMovies: [Movie] = []

    var favourites: [Movie] {
        get { favouriteMovies }
        set { favouriteMovies = newValue }
    }

    func isFavourite(_ movie: Movie) -> Bool {
        favourites.contains { $0.id == movie.id }
    }

    func toggleFavourite(_ movie: Movie) {
        if isFavourite(movie) {
            favouriteMovies.removeAll { $0.id == movie.id }
        } else {
            favouriteMovies.append(movie)
        }
    }
}
