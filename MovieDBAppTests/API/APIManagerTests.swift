//
//  APIManagerTests.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 21/06/25.
//

import XCTest
@testable import MovieDBApp

final class APIManagerTests: XCTestCase {
    var sut: APIManager!
    var mockSession: URLSessionMock!
    
    override func setUpWithError() throws {
        mockSession = URLSessionMock()
        sut = APIManager(session: mockSession)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockSession = nil
    }
    
    func testRequest_returnsDecodedData_forValidResponse() async throws {
        let expectedData = TestCodable(id: 1, name: "Success Item")
        let jsonData = try JSONEncoder().encode(expectedData)
        
        let urlString = "https://api.example.com/success"
        let request = APIRequest(urlString: urlString)
        let httpResponse = HTTPURLResponse(
            url: URL(string: urlString)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        mockSession.data = jsonData
        mockSession.response = httpResponse

        let receivedData: TestCodable = try await sut.request(
            apiRequest: request
        )

        XCTAssertEqual(
            receivedData,
            expectedData,
            "The decoded data should match the expected data."
        )
    }
    
    func testRequest_throwsError_forNon2xxStatusCode() async {
        let urlString = "https://api.example.com/error"
        let apiRequest = APIRequest(urlString: urlString)
        let httpResponse = HTTPURLResponse(
            url: URL(string: urlString)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!

        mockSession.data = "{}".data(using: .utf8)
        mockSession.response = httpResponse

        do {
            let _: EmptyDecodable = try await sut.request(
                apiRequest: apiRequest
            )
            XCTFail("Expected networkError but no error was thrown.")
        } catch let error as NetworkError {
            XCTAssertEqual(
                error,
                NetworkError.networkError,
                "Expected networkError for non-2xx status code."
            )
        } catch {
            XCTFail(
                "Expected NetworkError but received a different error: \(error.localizedDescription)"
            )
        }
    }
    
    func testRequest_throwsURLError_forInvalidURL() async {
        let invalidUrlString = ""
        let apiRequest = APIRequest(urlString: invalidUrlString)
       
        // No valid HTTPResponse or Data, as the error should occur during URL creation
        mockSession.data = nil
        mockSession.response = nil
        mockSession.error = URLError(.badURL)
        
        do {
            let _: EmptyDecodable = try await sut.request(
                apiRequest: apiRequest
            )
            XCTFail("Expected NetworkError.urlError but no error was thrown.")
        } catch let error as NetworkError {
            XCTAssertEqual(
                error,
                NetworkError.invalidUrl,
                "Expected urlError for an invalid URL string."
            )
        } catch {
            XCTFail(
                "Expected NetworkError but received a different error: \(error.localizedDescription)"
            )
        }
    }
   
    func testRequest_throwsDecodingError_forInvalidJSON() async {
        let urlString = "https://api.example.com/invalid_json"
        let apiRequest = APIRequest(urlString: urlString)
       
        // Provide JSON that does not match TestCodable's structure ('id' is a string, not Int)
        let invalidJsonData = "{\"id\":\"not_an_int\",\"name\":\"Bad Item\"}".data(
            using: .utf8
        )!
       
        let httpResponse = HTTPURLResponse(
            url: URL(string: urlString)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        mockSession.data = invalidJsonData
        mockSession.response = httpResponse
        mockSession.error = nil // No network error, the issue is with decoding

        do {
            let _: TestCodable = try await sut.request(apiRequest: apiRequest)
            XCTFail(
                "Expected NetworkError.parsingError but no error was thrown."
            )
        } catch let error as NetworkError {
            XCTAssertEqual(
                error,
                NetworkError.parsingError,
                "Expected parsingError for invalid JSON structure."
            )
        } catch {
            XCTFail(
                "Expected NetworkError but received a different error: \(error.localizedDescription)"
            )
        }
    }
   
    func testRequest_throwsNetworkFailureError_forNoInternetConnection() async {
        let urlString = "https://api.example.com/network_failure"
        let apiRequest = APIRequest(urlString: urlString)
       
        let networkConnectionError = URLError(
            .notConnectedToInternet
        )
       
        mockSession.data = nil
        mockSession.response = nil
        mockSession.error = networkConnectionError

        do {
            let _: EmptyDecodable = try await sut.request(
                apiRequest: apiRequest
            )
            XCTFail("Expected networkError but no error was thrown.")
        } catch let error as NetworkError {
            XCTAssertEqual(
                error,
                NetworkError.networkError,
                "Expected networkError for underlying network failure."
            )
        } catch {
            XCTFail(
                "Expected NetworkError but received a different error: \(error.localizedDescription)"
            )
        }
    }
}
