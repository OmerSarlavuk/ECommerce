//
//  HomeCollectionViewCell.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

import UIKit
import SnapKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let key = "HomeCollectionViewCell"
    
    private let component = TopImageBottomTitleAndValueAndStarView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.masksToBounds = true
        clipsToBounds  = true
        backgroundColor = .white
        
        addSubview(component)
        component.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("not init HomeCollectionViewCell")
    }
    
    func configure(with viewModel: TopImageBottomTitleAndValueAndStarView.ViewModel) {
        component.configure(with: viewModel)
    }
}
