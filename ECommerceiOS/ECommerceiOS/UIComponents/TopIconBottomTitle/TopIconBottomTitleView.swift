//
//  TopIconBottomTitleView.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit
import SnapKit
import Then

class TopIconBottomTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("not init TopIconBottomTitleView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyGradientBackground(colors: [.myBlue, .myBlue, .ringTwo])
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    private let topIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let bottomTitle = UILabel().then {
        $0.font = AppFont.medium(size: 16).font
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    struct ViewModel {
        let icon: UIImage
        let title: String
        let borderColor: UIColor
        let handleTap: VoidCallback
        
        init(icon: UIImage,
             title: String,
             borderColor: UIColor,
             handleTap: @escaping VoidCallback) {
            self.icon = icon
            self.title = title
            self.borderColor = borderColor
            self.handleTap = handleTap
        }
    }
    
    func configure(with viewModel: ViewModel) {
        topIcon.image = viewModel.icon
        bottomTitle.text = viewModel.title
        
        onTap(handler: viewModel.handleTap)
    }
    
}

private extension TopIconBottomTitleView {
    private func setupViews() {
        addSubview(topIcon)
        addSubview(bottomTitle)
    }
    
    private func setupConstraints() {
        topIcon.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(36)
        }
        
        bottomTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(topIcon.snp.bottom).offset(16)
        }
    }
}

