//
//  DependencyContainer.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 22/06/25.
//

import SwiftUI

final class DependencyContainer {
    let movieManager: MovieManagerProtocol
    let favouriteManager: FavouriteManagerProtocol

    init(
        movieManager: MovieManagerProtocol,
        favouriteManager: FavouriteManagerProtocol
    ) {
        self.movieManager = movieManager
        self.favouriteManager = favouriteManager
    }

    static func live() -> DependencyContainer {
        DependencyContainer(
            movieManager: MovieManager(),
            favouriteManager: FavouriteManager()
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
