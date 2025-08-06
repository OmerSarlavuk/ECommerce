//
//  HomeDetailViewDataSource.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

import UIKit

typealias HomeDetailViewDataSource = UICollectionViewDiffableDataSource<HomeDetailViewSection, HomeDetailViewItem>
typealias HomeDetailViewSnapshot = NSDiffableDataSourceSnapshot<HomeDetailViewSection, HomeDetailViewItem>

enum HomeDetailViewSection: Int, CaseIterable {
    case top
    case horizontalList
}

enum HomeDetailViewItem: Hashable {
    case top(ProductModel)
    case horizontalList(ProductModel)
}
