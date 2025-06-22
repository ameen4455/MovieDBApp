//
//  DependencyContainer.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 22/06/25.
//

import SwiftUI

final class DependencyContainer {
    let movieManager: MovieManager
    let favouriteManager: FavouriteManager

    init(
        movieManager: MovieManager,
        favouriteManager: FavouriteManager
    ) {
        self.movieManager = movieManager
        self.favouriteManager = favouriteManager
    }

    static func live() -> DependencyContainer {
        DependencyContainer(
            movieManager: TMDBMovieManager(),
            favouriteManager: UserDefaultsFavouriteManager()
        )
    }

    static func mock() -> DependencyContainer {
        DependencyContainer(
            movieManager: MockMovieManager(),
            favouriteManager: MockFavouriteManager.shared
        )
    }
}

private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer.live()
}

extension EnvironmentValues {
    var dependencyContainer: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}
