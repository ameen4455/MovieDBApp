//
//  MovieDBAppUITests.swift
//  MovieDBAppUITests
//
//  Created by Ameen Azeez on 21/06/25.
//

import XCTest
@testable import MovieDBApp

final class MovieDBAppUITests: XCTestCase {
    
    let movieTitle = "Mock Movie"
    let searchMovieTitle = "Search Mock Movie"
    
    @MainActor
    func testTapOnMovieShowsDetails() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UITestMode"]
        app.launch()

        // Assert that the movie cell exists
        let movieCell = app.staticTexts[movieTitle]
        XCTAssertTrue(movieCell.waitForExistence(timeout: 3), "Expected movie title to appear")

        // Tap the movie cell
        movieCell.tap()

        // Assert that the detail view is presented with the correct title
        let detailTitle = app.staticTexts[movieTitle]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: 3), "Expected to navigate to movie detail view")
    }
    
    @MainActor
    func testAddToFavouritesFlow() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UITestMode"]
        app.launch()

        // Tap on the movie
        let movieCell = app.staticTexts[movieTitle]
        XCTAssertTrue(movieCell.waitForExistence(timeout: 3), "Movie should be visible")
        movieCell.tap()

        // Tap on the favourite button
        let favButton = app.buttons["favourite_button"]
        XCTAssertTrue(favButton.waitForExistence(timeout: 2), "Favourite button should be visible")
        favButton.tap()

        // Navigate back
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Switch to Favourites tab
        app.tabBars.buttons["Favourites"].tap()

        // Verify the movie is now in favourites
        let favMovie = app.staticTexts[movieTitle]
        XCTAssertTrue(favMovie.waitForExistence(timeout: 3), "Movie should appear in Favourites")
    }
    
    @MainActor
    func testRemoveFromFavourites() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UITestMode"]
        app.launch()

        // Add movie to favourites
        let movieCell = app.staticTexts[movieTitle]
        XCTAssertTrue(movieCell.waitForExistence(timeout: 3), "Movie should be visible")
        movieCell.tap()

        let favButton = app.buttons["favourite_button"]
        XCTAssertTrue(favButton.waitForExistence(timeout: 2), "Favourite button should be visible")
        favButton.tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Go to Favourites tab
        app.tabBars.buttons["Favourites"].tap()

        let favMovieCell = app.staticTexts[movieTitle]
        XCTAssertTrue(favMovieCell.waitForExistence(timeout: 2), "Movie should appear in favourites after adding")
        
        favMovieCell.tap()

        // Unfavourite the movie
        XCTAssertTrue(favButton.waitForExistence(timeout: 2), "Favourite button should still be visible")
        favButton.tap()

        // Go back and verify it's removed
        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertFalse(favMovieCell.waitForExistence(timeout: 2), "Movie should be removed from favourites")
    }
    
    @MainActor
    func testSearchShowsResults() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UITestMode"]
        app.launch()

        // Access the search field
        let searchField = app.textFields["Search movies..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3), "Search field should be visible")

        // Type a query (that your mock data returns results for)
        searchField.tap()
        searchField.typeText("Search Mock")

        // Check that a result appears
        let resultCell = app.staticTexts[searchMovieTitle]
        XCTAssertTrue(resultCell.waitForExistence(timeout: 3), "Expected search result to appear")
    }
}
