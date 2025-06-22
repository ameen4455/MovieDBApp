//
//  MovieManagerTests.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 22/06/25.
//

import XCTest
@testable import MovieDBApp

class MovieManagerTests: XCTestCase {

    var sut: TMDBMovieManager!
    var mockAPIManager: MockAPIManager!

    override func setUpWithError() throws {
        mockAPIManager = MockAPIManager()
        sut = TMDBMovieManager(apiManager: mockAPIManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockAPIManager = nil
    }

    // MARK: - fetchPopularMovies Tests

    func test_fetchPopularMovies_correctRequestConstruction() async throws {
        let page = 1
        let expectedURLString = "\(APIConstants.tmdbBaseURL)\(APIConstants.popularMoviesPath)"
        let expectedQueryItems = [URLQueryItem(name: "page", value: "\(page)")]
        mockAPIManager.mockMovieResponse = MovieResponse(page: 1, results: [], totalPages: 0, totalResults: 0)

        _ = try await sut.fetchPopularMovies(page: page)

        XCTAssertNotNil(mockAPIManager.receivedAPIRequest)
        XCTAssertEqual(mockAPIManager.receivedAPIRequest?.urlString, expectedURLString)
        XCTAssertEqual(mockAPIManager.receivedAPIRequest?.queryItems, expectedQueryItems)
    }

    func test_fetchPopularMovies_successfulResponse() async throws {
        let expectedResponse = MovieResponse(page: 1, results:  [getTestMovie()], totalPages: 10, totalResults: 100)
        mockAPIManager.mockMovieResponse = expectedResponse

        let receivedResponse = try await sut.fetchPopularMovies(page: 1)

        XCTAssertEqual(receivedResponse, expectedResponse)
    }

    func test_fetchPopularMovies_throwsError() async {
        mockAPIManager.shouldThrowError = MockAPIManagerError.forcedError

        do {
            _ = try await sut.fetchPopularMovies(page: 1)
            XCTFail("fetchPopularMovies did not throw an error when expected.")
        } catch {
            XCTAssertEqual(error as? MockAPIManagerError, MockAPIManagerError.forcedError)
        }
    }
    
    // MARK: - searchMovies Tests

    func test_searchMovies_correctRequestConstruction() async throws {
        let query = "Inception"
        let page = 2
        let expectedURLString = "\(APIConstants.tmdbBaseURL)/search/movie"
        let expectedQueryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        mockAPIManager.mockMovieResponse = MovieResponse(page: 1, results: [], totalPages: 0, totalResults: 0)

        _ = try await sut.searchMovies(query: query, page: page)

        XCTAssertNotNil(mockAPIManager.receivedAPIRequest)
        XCTAssertEqual(mockAPIManager.receivedAPIRequest?.urlString, expectedURLString)
        XCTAssertEqual(mockAPIManager.receivedAPIRequest?.queryItems, expectedQueryItems)
    }

    func test_searchMovies_successfulResponse() async throws {
        // Given
        let expectedResponse = MovieResponse(page: 1, results: [getTestMovie()], totalPages: 5, totalResults: 50)
        mockAPIManager.mockMovieResponse = expectedResponse

        // When
        let receivedResponse = try await sut.searchMovies(query: "Inception", page: 1)

        // Then
        XCTAssertEqual(receivedResponse, expectedResponse)
    }

    func test_searchMovies_throwsError() async {
        // Given
        mockAPIManager.shouldThrowError = MockAPIManagerError.forcedError

        // When
        do {
            _ = try await sut.searchMovies(query: "Avatar", page: 1)
            XCTFail("searchMovies did not throw an error when expected.")
        } catch {
            // Then
            XCTAssertEqual(error as? MockAPIManagerError, MockAPIManagerError.forcedError)
        }
    }
}

enum MockAPIManagerError: Error, Equatable {
    case forcedError
}

class MockAPIManager: APIManagerProtocol {
    var receivedAPIRequest: APIRequest?
    var mockMovieResponse: MovieResponse?
    var shouldThrowError: Error?

    func request<T: Decodable>(apiRequest: APIRequest) async throws -> T {
        self.receivedAPIRequest = apiRequest

        if let error = shouldThrowError {
            throw error
        }

        if T.self == MovieResponse.self {
            guard let response = mockMovieResponse as? T else {
                fatalError("MockAPIManager: mockMovieResponse not set or wrong type")
            }
            return response
        } else {
            fatalError("MockAPIManager: Unsupported Decodable type")
        }
    }
}
