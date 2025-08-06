//
//  TargetType.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import Alamofire

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


enum NetworkTask {
    
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    
    case requestCodable(model: Codable, encoding: ParameterEncoding)
}


protocol TargetType {
    
    var baseURL: String {get}
    
    var path: String {get}
    
    var method: HTTPMethod {get}
    
    var task: NetworkTask {get}
    
    var headers: [String: String]? {get}
}


enum EncodingType {
    case jsonDefault
    case urlBody
    case urlDefault
    case queryString
    
    
    var encoding: ParameterEncoding {
        switch self {
        case .jsonDefault:
            return JSONEncoding.default
        case .urlBody:
            return URLEncoding.httpBody
        case .urlDefault:
            return URLEncoding.default
        case .queryString:
            return URLEncoding.queryString
        }
    }
}
