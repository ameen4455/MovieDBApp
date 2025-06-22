//
//  MovieDBAppApp.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import SwiftUI

@main
struct MovieDBAppApp: App {
    private let dependencyContainer: DependencyContainer

    init() {
        if ProcessInfo.processInfo.arguments.contains("UITestMode") {
            self.dependencyContainer = .mock()
        } else {
            self.dependencyContainer = .live()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dependencyContainer, dependencyContainer)
        }
    }
}
