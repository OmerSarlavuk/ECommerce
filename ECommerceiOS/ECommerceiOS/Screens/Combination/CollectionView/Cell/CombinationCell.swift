//
//  CombinationCell.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit
import SnapKit
import Then

class CombinationCell: UICollectionViewCell {
    static let key = "CombinationCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("not init CombinationCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyGradientBackground(colors: [.myBlue, .myBlue, .ringTwo])
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    private let title = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.font = AppFont.regular(size: 14).font
    }
    
    private let productStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    private let topProduct = TopImageBottomTitleAndValueAndStarView()
    private let bottomProduct = TopImageBottomTitleAndValueAndStarView()
    
    struct ViewModel {
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
        
    }
    
    func configure(with viewModel: ViewModel) {
        title.text = viewModel.title
        topProduct.configure(with: .init(imageUrl: viewModel.topProduct.imageUrl,
                                         title: viewModel.topProduct.productName,
                                         value: viewModel.topProduct.originalPrice,
                                         isStar: viewModel.topProduct.isTrend))
        bottomProduct.configure(with: .init(imageUrl: viewModel.bottomProduct.imageUrl,
                                         title: viewModel.bottomProduct.productName,
                                         value: viewModel.bottomProduct.originalPrice,
                                         isStar: viewModel.bottomProduct.isTrend))
    }
    
}

private extension CombinationCell {
    private func setupCell() {
        addSubview(title)
        addSubview(productStackView)
        [topProduct, bottomProduct].forEach {
            productStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        productStackView.snp.makeConstraints {
            $0.height.equalTo(270)
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
