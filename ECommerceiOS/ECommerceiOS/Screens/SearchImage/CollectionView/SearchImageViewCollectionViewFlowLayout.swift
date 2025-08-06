//
//  SearchImageViewCollectionViewFlowLayout.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit

struct SearchImageViewCollectionViewFlowLayout {
    static func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case SearchImageViewSection.horizontalList.rawValue:
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
