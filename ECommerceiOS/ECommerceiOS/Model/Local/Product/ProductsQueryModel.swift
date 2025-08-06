//
//  ProductsQueryModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

struct ProductsQueryModel {
    let start: Int
    let stop: Int
    let isMan: Int
    
    init(start: Int, stop: Int, isMan: Bool) {
        self.start = start
        self.stop = stop
        self.isMan = isMan ? 1 : 0
    }
}
