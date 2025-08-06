//
//  Combination.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

struct Combination: Codable, Hashable {
    let bottom: String
    let bottomProduct: ProductModel
    let occasionIndex: Int
    let shoes: String
    let top: String
    let topProduct: ProductModel
    
    enum CodingKeys: String, CodingKey {
        case bottom = "bottom"
        case bottomProduct = "bottom_product"
        case occasionIndex = "occasion_index"
        case shoes = "shoes"
        case top = "top"
        case topProduct = "top_product"
    }
    
}
