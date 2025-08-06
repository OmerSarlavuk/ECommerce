//
//  ImageRequestModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

struct ImageRequestModel: Codable {
    let image: String
    
    init(image: String) {
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
    }
}
