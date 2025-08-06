//
//  HomeDetailViewController.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

import UIKit
import SnapKit
import Then

final class HomeDetailViewBuilder: NSObject, Buildable {
    private var coordinator: HomeDetailViewCoordinator
    private var topProduct: ProductModel
    
    init(coordinator: HomeDetailViewCoordinator,
         topProduct: ProductModel) {
        self.coordinator = coordinator
        self.topProduct = topProduct
    }
    
    func build() -> UIViewController {
        let viewController = HomeDetailViewController(coordinator: coordinator,
                                                      topProduct: topProduct)
        return viewController
    }
}

final class HomeDetailViewController: BaseViewController {
    private var coordinator: HomeDetailViewCoordinator
    private var viewModel: HomeDetailViewModel?
    private var topProduct: ProductModel
    
    private enum CellType { case top, horizontal }
    
    init
    (coordinator: HomeDetailViewCoordinator,
     topProduct: ProductModel) {
        self.coordinator = coordinator
        self.topProduct = topProduct
        super.init()
    }
    
    required init?
    (coder: NSCoder) {
        fatalError("not init view controller -> HomeDetail")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ürün Detay"
        viewModel = HomeDetailViewModel()
        
        setupViews()
        setupConstraints()
        bindState()
        viewModel?.start(with: topProduct)
    }
    
    override func bindState() {
        viewModel?.stateChangeHandler = {[weak self ] state in
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
            case .snapshot(let topModel,
                           let horizontalModels):
                self.applySnapshot(with: topModel,
                                   with: horizontalModels)
            }
            
        }
    }
    
    lazy private var collectionView: UICollectionView = {
        let layout = HomeDetailCollectionViewFlowLayout.layout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(HomeDetailTopCell.self,
                                forCellWithReuseIdentifier: HomeDetailTopCell.key)
        collectionView.register(HomeDetailSimilaritiesCell.self,
                                forCellWithReuseIdentifier: HomeDetailSimilaritiesCell.key)
        collectionView.register(
            SectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeader.identifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy private var dataSource: HomeDetailViewDataSource = {
        dataSource = HomeDetailViewDataSource(collectionView: collectionView) {
            [ weak self ] collectionView, indexPath, itemIdentifier in guard let self else {
                return UICollectionViewCell()
            }
            switch itemIdentifier {
            case .top(let productModel):
                return buildTopCell(collectionView: collectionView,
                                    indexPath: indexPath,
                                    item: productModel)
            case .horizontalList(let productModel):
                return buildHorizontalCell(collectionView: collectionView,
                                           indexPath: indexPath,
                                           item: productModel)
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

// MARK: setup HomeDetailViewController extension
private extension HomeDetailViewController {
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            $0.height.equalTo(500)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: collectionView snapshot extension
private extension HomeDetailViewController {
    private func applySnapshot(with topListItem: [HomeDetailViewItem],
                               with horizontalListItem: [HomeDetailViewItem]) {
        var snapshot = HomeDetailViewSnapshot()
        snapshot.appendSections(HomeDetailViewSection.allCases)
        snapshot.appendItems(topListItem,
                             toSection: .top)
        snapshot.appendItems(horizontalListItem,
                             toSection: .horizontalList)
        DispatchQueue.main.async { [ weak self ] in
            guard let self else {
                return
            }
            self.dataSource.apply(snapshot,
                             animatingDifferences: true)
        }
    }
}

// MARK: collectionView configure and build cell
private extension HomeDetailViewController {
    private func buildTopCell(collectionView: UICollectionView,
                                  indexPath: IndexPath,
                                  item: ProductModel) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailTopCell.key,
                                                            for: indexPath) as? HomeDetailTopCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: .init(imageUrl: item.imageUrl,
                                   title: item.productName,
                                   value: item.originalPrice,
                                   isStar: item.isTrend,
                                   isAspectFill: false))
        return cell
    }
    
    private func buildHorizontalCell(collectionView: UICollectionView,
                                     indexPath: IndexPath,
                                     item: ProductModel) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDetailSimilaritiesCell.key,
                                                               for: indexPath) as? HomeDetailSimilaritiesCell else {
               return UICollectionViewCell()
           }
           
           cell.configure(with: .init(imageUrl: item.imageUrl,
                                      title: item.productName,
                                      value: item.originalPrice,
                                      isStar: item.isTrend,
                                      handleTap: { }))
           return cell
    }
    
    private func sectionHeaderCongigure(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: HomeDetailViewSection) -> UICollectionReusableView? {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeader.identifier,
            for: indexPath) as? SectionHeader else {
            return nil
        }
        
        switch section {
        default:
            sectionHeader.buttonTapHandler = { [ weak self ] in
                guard let self
                else {
                    return
                }
                
                self.coordinator.navigateCombination(animated: true,
                                                     imageUrl: topProduct.imageUrl)
            }
            
            sectionHeader.setupHeader(
                with: .init(title: "Benzer Ürünler",
                            buttonTitle: "Kombin Önerisi",
                            titleColor: .black,
                            isRightButton: true)
            )
        }
        
        return sectionHeader
    }
}
