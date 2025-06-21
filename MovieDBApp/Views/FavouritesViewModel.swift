//
//  FavouritesViewModel.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import Foundation

final class FavouritesViewModel: ObservableObject {
    @Published var favourites: [Movie] = []

    private let manager: FavouriteManagerProtocol

    init(manager: FavouriteManagerProtocol = FavouriteManager()) {
        self.manager = manager
    }

    func loadFavourites() {
        favourites = manager.favourites
    }
}
