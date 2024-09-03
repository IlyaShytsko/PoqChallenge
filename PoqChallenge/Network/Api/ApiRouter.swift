//
//  ApiRouter.swift
//  PoqChallenge
//
//  Created by Ilya Shytsko on 14/07/2024.
//

import Alamofire
import Foundation

struct RequestConfig {
    let path: String
    let method: HTTPMethod
    var params: Parameters?
    let encoding: ParameterEncoding
}

enum ApiRouter: URLRequestConvertible {
    
    // MARK: - Endpoints
    
    case organisation
    
    // MARK: - Endpoints configuration
    
    var config: RequestConfig {
        switch self {
            
        case .organisation:
            return RequestConfig(
                path: "orgs/square/repos",
                method: .get,
                encoding: URLEncoding.default
            )
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseUrl = AppConfig.baseGitHubURL
        let request = try URLRequest(url: baseUrl.asURL().appendingPathComponent(config.path), method: config.method)
        return try config.encoding.encode(request, with: config.params)
    }
}
