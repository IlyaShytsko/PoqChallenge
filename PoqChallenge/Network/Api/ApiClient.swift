//
//  ApiClient.swift
//  PoqChallenge
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import Foundation
import Alamofire

protocol ApiClientProtocol {
    static func request<Model: Decodable>(_ route: ApiRouter) async throws -> Model
}

final class ApiClient: ApiClientProtocol {
    static func request<Model: Decodable>(_ route: ApiRouter) async throws -> Model {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let response = await AF.request(route)
            .validate()
            .serializingDecodable(Model.self, decoder: decoder)
            .response
    
        switch response.result {
        case .success(let model):
            return model
        case .failure(let error):
            throw response.serviceError(error)
        }
    }
}
