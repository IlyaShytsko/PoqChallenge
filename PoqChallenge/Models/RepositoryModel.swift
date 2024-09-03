//
//  RepositoryModel.swift
//  PoqChallenge
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import Foundation

// MARK: - Repository

struct RepositoryModel: Codable, Hashable {
    let name: String
    let description: String?
}
