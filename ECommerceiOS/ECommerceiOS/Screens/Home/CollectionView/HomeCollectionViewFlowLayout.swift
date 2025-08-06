//
//  HomeCollectionViewFlowLayout.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

import UIKit

struct HomeCollectionViewFlowLayout {
    static func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout{ sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case HomeViewSection.list.rawValue:
                let config = LayoutConfig(
                    itemWidth: .fractionalWidth(0.5),
                    itemHeight: .absolute(380),
                    groupHeight: .absolute(380),
                    headerHeight: nil,
                    interGroupSpacing: 16,
                    contentInsets: NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                )
                return GenericCollectionViewLayout.createCarouselSection(with: config)
            default:
                return nil
            }
        }
    }
}
