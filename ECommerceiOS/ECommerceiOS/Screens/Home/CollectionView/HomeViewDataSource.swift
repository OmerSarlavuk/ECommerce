//
//  HomeViewDataSource.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

import UIKit

typealias HomeViewDataSource = UICollectionViewDiffableDataSource<HomeViewSection, HomeViewItem>
typealias HomeViewSnapshot = NSDiffableDataSourceSnapshot<HomeViewSection, HomeViewItem>

enum HomeViewSection: Int, CaseIterable {
    case list
}

enum HomeViewItem: Hashable {
    case list(ProductModel)
}
