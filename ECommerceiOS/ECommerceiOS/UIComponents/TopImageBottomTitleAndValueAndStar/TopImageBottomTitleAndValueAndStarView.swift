//
//  TopImageBottomTitleAndValueAndStarView.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class TopImageBottomTitleAndValueAndStarView: UIView {
    
    private let topImage = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private let bottomTitle = UILabel().then {
        $0.font = AppFont.regular(size: 12).font
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.textColor = .black
    }
    
    private let value = UILabel().then {
        $0.font = AppFont.medium(size: 14).font
        $0.textColor = .black
    }
    
    private let star = UILabel().then {
        $0.font = AppFont.regular(size: 10).font
        $0.textColor = .ringTwo
        $0.text = "Trend"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("not init TopImageBottomTitleAndValueAndStar")
    }
    
    struct ViewModel {
        let imageUrl: String
        let title: String
        let value: String
        let isStar: Bool
        let isAspectFill: Bool
        let handleTap: VoidCallback?
        
        init(imageUrl: String,
             title: String,
             value: String,
             isStar: Bool,
             isAspectFill: Bool = true,
             handleTap: VoidCallback? = nil) {
            self.imageUrl = imageUrl
            self.title = title
            self.value = value
            self.isStar = isStar
            self.isAspectFill = isAspectFill
            self.handleTap = handleTap
        }
        
    }
    
    func configure(with viewModel: ViewModel) {
        let url = URL(string: viewModel.imageUrl)
        topImage.kf.setImage(with: url)
        
        bottomTitle.text = viewModel.title
        value.text = viewModel.value
        star.isHidden = !viewModel.isStar
        
        topImage.contentMode = viewModel.isAspectFill ? .scaleAspectFill : .scaleAspectFit
        
        guard let handleTap = viewModel.handleTap else {
            return
        }
        
        self.onTap(handler: handleTap)
    }
    
}

private extension TopImageBottomTitleAndValueAndStarView {
    private func setupViews() {
        clipsToBounds = true
        layer.masksToBounds = true
        backgroundColor = .clear
        
        addSubview(topImage)
        addSubview(bottomTitle)
        addSubview(value)
        addSubview(star)
    }
    
    private func setupConstraints() {
        topImage.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(2.4 / 3.0)
        }
        
        value.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
            $0.height.equalTo(16)
        }
        
        bottomTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.top.equalTo(topImage.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().offset(-4)
            $0.bottom.equalTo(value.snp.top).offset(-4)
        }
        
        star.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalTo(value)
        }
    }
}
