//
//  GithubService.swift
//  PoqChallenge
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import Foundation

extension NetworkService {
    struct GithubService {
        var apiClient: ApiClientProtocol

        static func fetchRepositories(apiClient: ApiClientProtocol = ApiClient()) async throws -> [RepositoryModel] {
            let repositories: [RepositoryModel] = try await ApiClient.request(.organisation)
            return repositories
        }
    }
}
