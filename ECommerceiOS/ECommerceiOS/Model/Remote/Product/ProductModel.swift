//
//  ProductModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

struct ProductModel: Codable, Hashable {
    let id: Int128
    let imageUrl: String
    let isMan: Bool
    let isTrend: Bool
    let originalPrice: String
    let productName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case imageUrl = "ImageUrl"
        case isMan = "IsMan"
        case isTrend = "IsTrend"
        case originalPrice = "OriginalPrice"
        case productName = "ProductName"
    }
    
    init(id: Int128,
         imageUrl: String,
         isMan: Bool,
         isTrend: Bool,
         originalPrice: String,
         productName: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.isMan = isMan
        self.isTrend = isTrend
        self.originalPrice = originalPrice
        self.productName = productName
    }
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
