//
//  MainTabView.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MovieListView()
                .tabItem {
                    Label("Home", systemImage: "film")
                }

            FavouritesListView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }
    }
}
