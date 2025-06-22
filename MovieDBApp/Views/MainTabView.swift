//
//  MainTabView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.dependencyContainer) private var container: DependencyContainer

    var body: some View {
        TabView {
            MovieListView(movieManager: container.movieManager)
                .tabItem {
                    Label("Home", systemImage: "film")
                }

            FavouritesListView(manager: container.favouriteManager)
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }
    }
}
