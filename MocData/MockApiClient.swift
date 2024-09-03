//
//  MockApiClient.swift
//  PoqChallenge
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import Foundation

final class MockApiClient {
    enum MockScenario {
        case success
        case failure(Error)
    }

    static var mockScenario: MockScenario = .success
    static var mockData: Data? = nil

    static func request<Model>(_ route: ApiRouter) async throws -> Model where Model : Decodable {
        switch mockScenario {
        case .success:
            if let data = mockData {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .secondsSince1970
                return try decoder.decode(Model.self, from: data)
            } else {
                fatalError("Mock data not set for success scenario")
            }
        case .failure(let error):
            throw error
        }
    }

    static func prepareMockData<Model: Encodable>(for model: Model) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            mockData = encoded
        }
    }
}
