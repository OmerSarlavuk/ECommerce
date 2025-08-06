//
//  LeftLabelRightButtonView.swift
//  HoldingApp
//
//  Created by OmerSarlavuk on 1.08.2025.
//


import UIKit
import SnapKit
import Then

class LeftLabelRightButtonView: UIView {
    
    public class ViewModel {
        let title: String
        let buttonTitle: String?
        let titleFontSize: CGFloat
        let titleColor: UIColor
        let tapHandler: VoidCallback?
        
        init(title: String,
             buttonTitle: String? = nil,
             titleFontSize: CGFloat = 18,
             titleColor: UIColor = .mainText,
             tapHandler: VoidCallback? = {}) {
            self.title = title
            self.buttonTitle = buttonTitle
            self.titleFontSize = titleFontSize
            self.titleColor = titleColor
            self.tapHandler = tapHandler
        }
    }
    
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .clear
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    private let btnRight = UIButton().then {
        $0.setTitleColor(.ringOne, for: .normal)
        $0.titleLabel?.font = AppFont.medium(size: 14).font
    }
    
    private let titleLabel = UILabel().then {
        $0.font = AppFont.medium(size: 18).font
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private var viewModel: ViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        titleLabel.font = AppFont.medium(size: viewModel.titleFontSize).font
        titleLabel.textColor = viewModel.titleColor
        
        btnRight.setTitle(viewModel.buttonTitle, for: .normal)
        
        if let tapHandler = viewModel.tapHandler {
            btnRight.onTap(handler: tapHandler)
        }
    }
    
    private func setupUI() {
        addSubview(horizontalStackView)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(spacer)
        horizontalStackView.addArrangedSubview(btnRight)
        setupConstraints()
    }
    
    private func setupConstraints() {
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setTitle(to text: String) {
        titleLabel.text = text
    }
    
}
