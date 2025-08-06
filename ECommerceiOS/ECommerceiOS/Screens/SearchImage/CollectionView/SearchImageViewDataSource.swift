//
//  SearchImageViewDataSource.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit

typealias SearchImageViewDataSource = UICollectionViewDiffableDataSource<SearchImageViewSection, SearchImageViewItem>
typealias SearchImageViewSnapshot = NSDiffableDataSourceSnapshot<SearchImageViewSection, SearchImageViewItem>

enum SearchImageViewSection: Int, CaseIterable {
    case horizontalList
}

enum SearchImageViewItem: Hashable {
    case horizontalList(ProductModel)
}
