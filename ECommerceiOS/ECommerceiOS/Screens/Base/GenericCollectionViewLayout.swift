//
//  GenericCollectionViewLayout.swift
//  HoldingApp
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import UIKit

struct GenericCollectionViewLayout {
    
    static func createLayout(for sectionType: SectionType, layoutConfig: LayoutConfig) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            switch sectionType {
            case .carousel:
                return createCarouselSection(with: layoutConfig)
            case .list:
                return createListSection(with: layoutConfig)
            }
        }
    }
    
    // Parametric carousel section
    public static func createCarouselSection(with config: LayoutConfig) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: config.itemWidth, heightDimension: config.itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: config.groupHeight)
        //let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(config.interGroupSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        
        // Add optional header
        if let headerHeight = config.headerHeight {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: headerHeight)
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        
        section.interGroupSpacing = config.interGroupSpacing
        section.contentInsets = config.contentInsets
        
        return section
    }
    
    // Parametric list section
    public static func createListSection(with config: LayoutConfig,
                                         to isVertical: Bool = true,
                                         enableHorizontalScroll: Bool = false) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: config.itemWidth,
            heightDimension: config.itemHeight
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: config.itemWidth,
            heightDimension: config.groupHeight
        )
        let group = isVertical ?
        NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item]) :
        NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        if enableHorizontalScroll {
            section.orthogonalScrollingBehavior = .continuous
        }
        
        if let headerHeight = config.headerHeight {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: headerHeight)
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [header]
        }
        
        section.interGroupSpacing = config.interGroupSpacing
        section.contentInsets = config.contentInsets
        
        return section
    }
    
    
    public static func createListSection(with config: LayoutConfig, listConfig: UICollectionLayoutListConfiguration,layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        // Create a list-based section using the configuration
        let section = NSCollectionLayoutSection.list(using: listConfig, layoutEnvironment: layoutEnvironment)
        
        // Add inter-group spacing if needed
        section.interGroupSpacing = config.interGroupSpacing
        section.contentInsets = config.contentInsets
        
        
        
        // Optionally, add a header if it's defined in the config
        if let headerHeight = config.headerHeight {
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: headerHeight)
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
    
}

// Enum for different section types
enum SectionType {
    case carousel
    case list
}

// Struct to hold configuration for layout parameters
struct LayoutConfig {
    let itemWidth: NSCollectionLayoutDimension
    let itemHeight: NSCollectionLayoutDimension
    let groupHeight: NSCollectionLayoutDimension
    let headerHeight: NSCollectionLayoutDimension?
    let interGroupSpacing: CGFloat
    let contentInsets: NSDirectionalEdgeInsets
    
    init(itemWidth: NSCollectionLayoutDimension,
         itemHeight: NSCollectionLayoutDimension,
         groupHeight: NSCollectionLayoutDimension,
         headerHeight: NSCollectionLayoutDimension?,
         interGroupSpacing: CGFloat,
         contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)) {
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.groupHeight = groupHeight
        self.headerHeight = headerHeight
        self.interGroupSpacing = interGroupSpacing
        self.contentInsets = contentInsets
    }
    
    // Convenience initializers for specific layouts
    static func defaultCarouselConfig() -> LayoutConfig {
        return LayoutConfig(itemWidth: .fractionalWidth(1.0),
                            itemHeight: .estimated(50),
                            groupHeight: .estimated(200),
                            headerHeight: .estimated(50),
                            interGroupSpacing: 10)
    }
    
    static func defaultListConfig() -> LayoutConfig {
        return LayoutConfig(itemWidth: .fractionalWidth(1.0),
                            itemHeight: .absolute(134),
                            groupHeight: .absolute(134),
                            headerHeight: nil,
                            interGroupSpacing: 10)
    }
    
}
