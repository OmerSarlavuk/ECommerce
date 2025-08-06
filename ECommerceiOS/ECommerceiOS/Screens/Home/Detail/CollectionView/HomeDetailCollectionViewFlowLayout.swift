//
//  HomeDetailCollectionViewFlowLayout.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

import UIKit

struct HomeDetailCollectionViewFlowLayout {
    static func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case HomeDetailViewSection.top.rawValue:
                let config = LayoutConfig(
                    itemWidth: .fractionalWidth(1.0),
                    itemHeight: .absolute(420),
                    groupHeight: .absolute(420),
                    headerHeight: nil,
                    interGroupSpacing: 30,
                    contentInsets: .init(top: 0, leading: 0, bottom: 30, trailing: 0)
                )
                return GenericCollectionViewLayout.createListSection(with: config)
            case HomeDetailViewSection.horizontalList.rawValue:
                let config = LayoutConfig(
                    itemWidth: .absolute(180),
                    itemHeight: .absolute(230),
                    groupHeight: .absolute(230),
                    headerHeight: .estimated(32),
                    interGroupSpacing: 16,
                    contentInsets: .init(top: 10, leading: 16, bottom: 0, trailing: 16))
                return GenericCollectionViewLayout.createListSection(with: config,
                                                                     to: false,
                                                                     enableHorizontalScroll: true)
            default:
                return nil
            }
        }
    }
}
