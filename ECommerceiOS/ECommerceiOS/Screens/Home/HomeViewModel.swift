//
//  HomeViewModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import Foundation

class HomeViewModel: ViewModel {
    var stateChangeHandler: Callback<HomeViewState>?
    
    private var api = ECommerceAPI()
    
    private var startRow: Int = 0
    private var stopRow: Int = 30
    
    private var isMan: Bool = true
    private var isLoading = false
    
    private let imageBaseURL = "https://cdn.dsmcdn.com"
    
    func start(with data: Any?) {
        fetchProducts()
    }
    
    func loadDatas() {
        startRow = stopRow
        stopRow = stopRow + 30
        fetchProducts()
    }
}

// MARK: network extension
private extension HomeViewModel {
    private func fetchProducts() {
        guard !isLoading else { return }
        isLoading = true
        
        stateChangeHandler?(.base(.startLoadingIndicator))
        let queryModel: ProductsQueryModel = ProductsQueryModel(start: startRow,
                                                                stop: stopRow,
                                                                isMan: isMan)
        api.getProducts(queryModel: queryModel) { [ weak self ] result in
            guard let self else {
                return
            }
            self.stateChangeHandler?(.base(.removeLoadingIndicator))
            self.isLoading = false
            
            switch result {
            case .success(let response):
                if response.code == Constant.RESPONSE_SUCCESS_CODE {
                    self.configureProducts(with: response.data)
                } else {
                    self.stateChangeHandler?(.base(.failureService(errorMessage: response.message)))
                }
            case .failure(let error):
                self.stateChangeHandler?(.base(.failureService(errorMessage: error.localizedDescription)))
            }
        }
    }
}

// MARK: handle data and pre-process extension
private extension HomeViewModel {
    private func configureProducts(with products: [ProductModel]) {
        stateChangeHandler?(.snapshot(handleHomeViewListItem(with: products)))
    }
}

// MARK: data convert HomeListItem extension
private extension HomeViewModel {
    private func handleHomeViewListItem(with products: [ProductModel]) -> [HomeViewItem] {
        return products.map { productModel in
            return .list(
                .init(id: productModel.id,
                      imageUrl: imageBaseURL + productModel.imageUrl,
                      isMan: productModel.isMan,
                      isTrend: productModel.isTrend,
                      originalPrice: productModel.originalPrice + " " + "TL",
                      productName: productModel.productName)
            )
        }
    }
}
