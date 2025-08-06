//
//  CombinationViewDataSource.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit

typealias CombinationViewDataSource = UICollectionViewDiffableDataSource<CombinationViewSection, CombinationViewItem>
typealias CombinationViewSnapshot = NSDiffableDataSourceSnapshot<CombinationViewSection, CombinationViewItem>

enum CombinationViewSection: Int, CaseIterable {
    case list
}

enum CombinationViewItem: Hashable {
    case list(CombinationListItem)
}

struct CombinationListItem: Hashable {
    let id: UUID = UUID()
    let title: String
    let topProduct: ProductModel
    let bottomProduct: ProductModel
    
    init(title: String,
         topProduct: ProductModel,
         bottomProduct: ProductModel) {
        self.title = title
        self.topProduct = topProduct
        self.bottomProduct = bottomProduct
    }
    
    static func == (lhs: CombinationListItem, rhs: CombinationListItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
