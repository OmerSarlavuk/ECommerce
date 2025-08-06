//
//  SectionHeader.swift
//  HoldingApp
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import UIKit
import SnapKit

class SectionHeader: UICollectionReusableView {
    
    static var identifier = "SectionHeader"
    
    private let headerView = LeftLabelRightButtonView()
    
    var buttonTapHandler: VoidCallback?
    
    struct ViewModel {
        let title: String
        let buttonTitle: String?
        let fontSize: CGFloat
        let titleColor: UIColor
        let isRightButton: Bool
        
        init(title: String,
             buttonTitle: String? = nil,
             fontSize: CGFloat = 14.0,
             titleColor: UIColor = .tintColor,
             isRightButton: Bool = false) {
            self.title = title
            self.buttonTitle = buttonTitle
            self.fontSize = fontSize
            self.titleColor = titleColor
            self.isRightButton = isRightButton
        }
    }
    
    //MARK: - Header Public Method
    
    func setupHeader(with viewModel: ViewModel) {
        setupUI()
        configure(with: viewModel)
    }
}

//MARK: - Header UI

private extension SectionHeader {
    func configure(with viewModel: ViewModel) {
        if viewModel.isRightButton {
            headerView.configure(with: LeftLabelRightButtonView.ViewModel(
                title: viewModel.title,
                buttonTitle: viewModel.buttonTitle,
                titleFontSize: viewModel.fontSize,
                titleColor: viewModel.titleColor,
                tapHandler: self.buttonTapHandler))
        } else {
            headerView.configure(with: LeftLabelRightButtonView.ViewModel(
                title: viewModel.title,
                titleFontSize: viewModel.fontSize,
                titleColor: viewModel.titleColor))
        }
    }
    
    func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        addSubview(headerView)
    }
    
    func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
