//
//  TextRequestModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

struct TextRequestModel: Codable {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
    }
}
