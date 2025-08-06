//
//  BaseResponseModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

struct BaseResponseModel<T: Codable>: Codable {
    let code: Int
    let data: T
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case data = "data"
        case message = "message"
    }
}
