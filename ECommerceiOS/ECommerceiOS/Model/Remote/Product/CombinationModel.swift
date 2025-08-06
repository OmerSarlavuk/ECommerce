//
//  CombinationModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

struct CombinationModel: Codable, Hashable {
    let accessories: [String]
    let combinations: [Combination]
    let occasions: [String]
    let style: String
    
    enum CodingKeys: String, CodingKey {
        case accessories = "accessories"
        case combinations = "combinations"
        case occasions = "occasions"
        case style = "style"
    }
    
}
