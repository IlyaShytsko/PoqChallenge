//
//  PoqChallengeTests.swift
//  PoqChallengeTests
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import XCTest
@testable import PoqChallenge

final class PoqChallengeTests: XCTestCase {

    func setUpMockSuccess() {
        let repository = RepositoryModel(name: "sample-repo", description: "A sample repository for testing.")
        MockApiClient.prepareMockData(for: [repository])
        MockApiClient.mockScenario = .success
    }

    func setUpMockFailure() {
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        MockApiClient.mockScenario = .failure(error)
    }
    
    func testFetchRepositories_WithSuccess_ReturnsRepositories() async {
        setUpMockSuccess()

        do {
            let repositories: [RepositoryModel] = try await MockApiClient.request(.organisation)
            XCTAssertEqual(repositories.count, 1)
            XCTAssertEqual(repositories.first?.name, "sample-repo")
        } catch {
            XCTFail("Expected successful fetch, received error: \(error)")
        }
    }
    
    func testFetchRepositories_WithFailure_ThrowsError() async {
        setUpMockFailure()

        do {
            let _: [RepositoryModel] = try await MockApiClient.request(.organisation)
            XCTFail("Expected failure, but request was successful")
        } catch let caughtError as NSError {
            guard case .failure(let expectedError) = MockApiClient.mockScenario else {
                XCTFail("Mock scenario was not set to failure as expected")
                return
            }

            let expectedNSError = expectedError as NSError
            XCTAssertEqual(caughtError.domain, expectedNSError.domain, "Error domain does not match")
            XCTAssertEqual(caughtError.code, expectedNSError.code, "Error code does not match")
            XCTAssertEqual(caughtError.localizedDescription, expectedNSError.localizedDescription, "Error description does not match")
        } catch {
            XCTFail("Unexpected error type received: \(error)")
        }
    }
    
}
