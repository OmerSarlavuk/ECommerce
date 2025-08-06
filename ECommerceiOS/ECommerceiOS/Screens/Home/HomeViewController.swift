//
//  HomeViewController.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import UIKit
import SnapKit
import Then

final class HomeViewBuilder: Buildable {
    private var coordinator: HomeViewCoordinator
    
    init(coordinator: HomeViewCoordinator) {
        self.coordinator = coordinator
    }
    
    func build() -> UIViewController {
        let viewController = HomeViewController(coordinator: coordinator)
        return viewController
    }
}

class HomeViewController: BaseViewController {
    private var coordinator: HomeViewCoordinator
    private var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        
        setupViews()
        setupConstraints()
        bindState()
        configure()
        viewModel?.start(with: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
    }
    
    init
    (coordinator: HomeViewCoordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    required init?
    (coder: NSCoder) {
        fatalError("not init view controller -> Home")
    }
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "Aramak istediğiniz metni giriniz."
        $0.layer.cornerRadius = 10
    }
    
    private let searchImage = UIButton().then {
        $0.setImage(.search,
                    for: .normal)
    }
    
    lazy private var collectionView: UICollectionView = {
        let layout = HomeCollectionViewFlowLayout.layout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.key)
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy private var dataSource = HomeViewDataSource(collectionView: collectionView) {
        [ weak self ] collectionView, indexPath, itemIdentifier in guard let self else {
            return UICollectionViewCell()
        }
        switch itemIdentifier {
        case .list(let productModel):
            return buildListCell(collectionView: collectionView,
                                 indexPath: indexPath,
                                 item: productModel)
        }
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
                case .failureService(let errorMessage):
                    self.showToast(message: errorMessage)
                case .removeLoadingIndicator:
                    self.hideLoading()
                }
            case .snapshot(let homeViewItems):
                self.applySnapshot(with: homeViewItems)
            }
        }
    }
    
}

// MARK: setup HomeViewController extension
private extension HomeViewController {
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(searchImage)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        searchImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(36)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(searchImage)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(searchImage.snp.leading).offset(-10)
            $0.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configure() {
        searchImage.onTap { [ weak self ] in
            guard let self else {
                return
            }
            coordinator.navigateSearchImage(animated: true)
        }
    }
}

// MARK: collectionView snapshot extension
private extension HomeViewController {
    private func applySnapshot(with homeViewListItem: [HomeViewItem]) {
        var snapshot = HomeViewSnapshot()
        snapshot.appendSections(HomeViewSection.allCases)
        snapshot.appendItems(homeViewListItem,
                             toSection: .list)
        dataSource.apply(snapshot,
                              animatingDifferences: true)
        
    }
}

// MARK: collectionView configure and build cell
private extension HomeViewController {
    private func buildListCell(collectionView: UICollectionView, indexPath: IndexPath, item: ProductModel) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.key,
                                                            for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: .init(imageUrl: item.imageUrl,
                                   title: item.productName,
                                   value: item.originalPrice,
                                   isStar: item.isTrend,
                                   handleTap: { [ weak self ] in
            guard let self else {
                return
            }
            
            self.coordinator.navigateHomeDetail(animated: true,
                                                productModel: item)
        }))
        return cell
    }
}
// MARK: collectionView delegate extension
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastItemIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex &&
           indexPath.item == lastItemIndex {
            viewModel?.loadDatas()
        }
    }
}
