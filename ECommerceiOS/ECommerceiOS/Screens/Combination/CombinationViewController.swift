//
//  CombinationViewController.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

import UIKit
import SnapKit
import Then
import Lottie

final class CombinationViewBuilder: NSObject, Buildable {
    private var coordinator: CombinationViewCoordinator
    private var imageUrl: String
    
    init(coordinator: CombinationViewCoordinator,
         imageUrl: String) {
        self.coordinator = coordinator
        self.imageUrl = imageUrl
    }
    
    func build() -> UIViewController {
        let viewController = CombinationViewController(coordinator: coordinator,
                                                       imageUrl: imageUrl)
        return viewController
    }
}

final class CombinationViewController: BaseViewController {
    private var coordinator: CombinationViewCoordinator
    private var imageUrl: String
    private var viewModel: CombinationViewModel?
    
    init(coordinator: CombinationViewCoordinator,
         imageUrl: String) {
        self.coordinator = coordinator
        self.imageUrl = imageUrl
        super.init()
    }
    
    required init?
    (coder: NSCoder) {
        fatalError("not init view controller -> Combination")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Kişisel Moda Asistanı"
        viewModel = CombinationViewModel()
        
        setupViews()
        setupConstraints()
        bindState()
        viewModel?.start(with: imageUrl)
    }
    
    override func bindState() {
        viewModel?.stateChangeHandler = {[ weak self ] state in
            guard let self else {
                return
            }
            
            switch state {
            case .base(let baseViewState):
                switch baseViewState {
                case .startLoadingIndicator:
                    self.showLoading()
                case .removeLoadingIndicator:
                    self.hideLoading()
                case .failureService(let errorMessage):
                    self.showToast(message: errorMessage)
                }
            case .snapshot(let combinationViewItems):
                self.applySnapshot(with: combinationViewItems)
            }
            
        }
    }
    
    private let animation = LottieAnimationView(name: "designer").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.animationSpeed = 1.0
        $0.play()
    }
    
    lazy private var collectionView: UICollectionView = {
        let layout = CombinationCollectionViewFlowLayout.layout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(CombinationCell.self,
                                forCellWithReuseIdentifier: CombinationCell.key)
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy private var dataSource: CombinationViewDataSource = {
        dataSource = CombinationViewDataSource(collectionView: collectionView) {
            [ weak self ] collectionView, indexPath, itemIdentifier in guard let self else {
                return UICollectionViewCell()
            }
            switch itemIdentifier {
            case .list(let combinationListItem):
                return sectionListConfigure(collectionView: collectionView,
                                            indexPath: indexPath,
                                            item: combinationListItem)
            }
        }
        
        dataSource.supplementaryViewProvider  = { [weak self] collectionView, kind, indexPath in
            guard let self else {
                return nil
            }
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            return self.sectionHeaderCongigure(collectionView: collectionView,
                                               kind: kind,
                                               indexPath: indexPath,
                                               section: section)
            
        }
        
        return dataSource
    }()
    
}

// MARK: collectionView snapshot extension
private extension CombinationViewController {
    private func applySnapshot(with items: [CombinationViewItem]) {
        var snapshot = CombinationViewSnapshot()
        snapshot.appendSections(CombinationViewSection.allCases)
        snapshot.appendItems(items,
                             toSection: .list)
        DispatchQueue.main.async { [ weak self ] in
            guard let self else {
                return
            }
            
            self.dataSource.apply(snapshot,
                                  animatingDifferences: true)
        }
    }
}

// MARK: setup CombinationViewController extension
private extension CombinationViewController {
    private func setupViews() {
        view.addSubview(animation)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        animation.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(250)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(animation.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

// MARK: collectionView build and configure cell
private extension CombinationViewController {
    private func sectionListConfigure(collectionView: UICollectionView, indexPath: IndexPath, item: CombinationListItem) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CombinationCell.key,
                                                            for: indexPath) as? CombinationCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: .init(title: item.title,
                                   topProduct: item.topProduct,
                                   bottomProduct: item.bottomProduct))
        return cell
    }
    
    private func sectionHeaderCongigure(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: CombinationViewSection) -> UICollectionReusableView? {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeader.identifier,
            for: indexPath) as? SectionHeader else {
            return nil
        }
        
        switch section {
        default:
            sectionHeader.setupHeader(
                with: .init(title: "Sizin için Önerilen Kombinler",
                            titleColor: .black,
                            isRightButton: false)
            )
        }
        
        return sectionHeader
    }
}
