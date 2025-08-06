//
//  SearchImageViewController.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import UIKit
import SnapKit
import Then
import Lottie

final class SearchImageViewBuilder: NSObject, Buildable {
    private var coordinator: SearchImageViewCoordinator
    
    init(coordinator: SearchImageViewCoordinator) {
        self.coordinator = coordinator
    }
    
    func build() -> UIViewController {
        let viewController = SearchImageViewController(coordinator: coordinator)
        return viewController
    }
}

final class SearchImageViewController: BaseViewController {
    private var coordinator: SearchImageViewCoordinator
    private var viewModel: SearchImageViewModel?
    
    init
    (coordinator: SearchImageViewCoordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    required init?
    (coder: NSCoder) {
        fatalError("not init view controller -> Home")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ürün Arama Asistanı"
        viewModel = SearchImageViewModel()
        
        setupViews()
        setupConstraints()
        configure()
        bindState()
        viewModel?.start(with: nil)
    }
    
    override func bindState() {
        viewModel?.stateChangeHandler = { [weak self ] state in
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
            case .snapshot(let horizontalViewItems):
                self.applySnapshot(with: horizontalViewItems)
            }
            
        }
    }
    
    private let animation = LottieAnimationView(name: "marketing").then {
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .loop
        $0.animationSpeed = 1.5
        $0.play()
    }
    
    private let cameraAndGalleryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    private let camera = TopIconBottomTitleView()
    private let gallery = TopIconBottomTitleView()
    
    lazy private var collectionView: UICollectionView = {
        let layout = SearchImageViewCollectionViewFlowLayout.layout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
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
    
    lazy private var dataSource: SearchImageViewDataSource = {
        dataSource = SearchImageViewDataSource(collectionView: collectionView) {
            [ weak self ] collectionView, indexPath, itemIdentifier in guard let self else {
                return UICollectionViewCell()
            }
            switch itemIdentifier {
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

// MARK: setup CombinationViewController extension
private extension SearchImageViewController {
    private func setupViews() {
        view.addSubview(animation)
        view.addSubview(cameraAndGalleryStackView)
        [camera, gallery].forEach {
            cameraAndGalleryStackView.addArrangedSubview($0)
        }
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        animation.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(200)
        }
        
        cameraAndGalleryStackView.snp.makeConstraints {
            $0.top.equalTo(animation.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(cameraAndGalleryStackView.snp.bottom).offset(48)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configure() {
        camera.configure(with: .init(icon: .camera.withTintColor(.white,
                                                                 renderingMode: .alwaysOriginal),
                                     title: "Fotoğraf Çek",
                                     borderColor: .black,
                                     handleTap: { [ weak self ] in
            guard let self else {
                return
            }
            self.openCamera()
        }))
        
        gallery.configure(with: .init(icon: .gallery.withTintColor(.white,
                                                                   renderingMode: .alwaysOriginal),
                                      title: "Galeriden Yükle",
                                      borderColor: .black,
                                      handleTap: { [ weak self ] in
            guard let self else {
                return
            }
            self.openGallery()
        }))
    }
}

// MARK: extension camera and gallery process
extension SearchImageViewController {
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showToast(message: "Kamera kullanılabilir değil")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }

    private func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            showToast(message: "Galeriye erişilemiyor")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        present(picker, animated: true)
    }
}

// MARK: picker delegate extension
extension SearchImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            handleSelectedImage(selectedImage)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func handleSelectedImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        let base64 = imageData.base64EncodedString()
        viewModel?.searchImageToAPI(to: base64)
    }
}

// MARK: collectionView snapshot extension
private extension SearchImageViewController {
    private func applySnapshot(with horizontalListItem: [SearchImageViewItem]) {
        var snapshot = SearchImageViewSnapshot()
        snapshot.appendSections(SearchImageViewSection.allCases)
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
private extension SearchImageViewController {
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
    
    private func sectionHeaderCongigure(collectionView: UICollectionView, kind: String, indexPath: IndexPath, section: SearchImageViewSection) -> UICollectionReusableView? {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeader.identifier,
            for: indexPath) as? SectionHeader else {
            return nil
        }
        
        switch section {
        default:
            sectionHeader.setupHeader(
                with: .init(title: "Benzer Ürünler",
                            titleColor: .black,
                            isRightButton: false)
            )
        }
        
        return sectionHeader
    }
}
