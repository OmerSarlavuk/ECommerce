//
//  ImageAndTextRequestModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

struct ImageAndTextRequestModel: Codable {
    let image: String
    let text: String
    
    init(image: String,
         text: String) {
        self.image = image
        self.text = text
    }
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
        case text = "text"
    }
    
}
