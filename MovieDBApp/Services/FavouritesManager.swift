//
//  FavouritesManager.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

protocol FavouriteManager {
    var favourites: [Movie] { get }
    func toggleFavourite(_ movie: Movie)
    func isFavourite(_ movie: Movie) -> Bool
}

final class UserDefaultsFavouriteManager: FavouriteManager {
    private let key = "favourite_movies"
    private let defaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    var favourites: [Movie] {
        get {
            guard let data = defaults.data(forKey: key),
                  let decoded = try? JSONDecoder().decode([Movie].self, from: data) else {
                return []
            }
            return decoded
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: key)
            }
        }
    }

    func isFavourite(_ movie: Movie) -> Bool {
        favourites.contains { $0.id == movie.id }
    }

    func toggleFavourite(_ movie: Movie) {
        var current = favourites
        if isFavourite(movie) {
            current.removeAll { $0.id == movie.id }
        } else {
            current.append(movie)
        }
        favourites = current
    }
}
