//
//  CombinationCollectionViewFlowLayout.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit

struct CombinationCollectionViewFlowLayout {
    static func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case CombinationViewSection.list.rawValue:
                let config = LayoutConfig(
                    itemWidth: .fractionalWidth(1.0),
                    itemHeight: .absolute(320),
                    groupHeight: .absolute(320),
                    headerHeight: .estimated(32),
                    interGroupSpacing: 16,
                    contentInsets: .init(top: 0, leading: 16, bottom: 0, trailing: 16)
                )
                return GenericCollectionViewLayout.createListSection(with: config)
            default:
                return nil
            }
        }
    }
}
