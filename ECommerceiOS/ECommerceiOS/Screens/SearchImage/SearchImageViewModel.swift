//
//  SearchImageViewModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 6.08.2025.
//

import Foundation

final class SearchImageViewModel: ViewModel {
    var stateChangeHandler: Callback<SearchImageViewState>?
    
    private var api = ECommerceAPI()
    
    private let imageBaseURL = "https://cdn.dsmcdn.com"
    
    func start(with data: Any?) {}
    
    func searchImageToAPI(to base64: String) {
        searchImage(to: base64)
    }
}

// MARK: network extension
private extension SearchImageViewModel {
    private func searchImage(to base64: String) {
        stateChangeHandler?(.base(.startLoadingIndicator))
        
        let request: ImageRequestModel = ImageRequestModel(image: base64)
        
        api.searchImage(request: request) { [ weak self ]  result in
            guard let self else {
                return
            }
            self.stateChangeHandler?(.base(.removeLoadingIndicator))
            
            switch result {
            case .success(let response):
                if response.code == Constant.RESPONSE_SUCCESS_CODE {
                    self.configureSearchImage(with: response.data)
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
private extension SearchImageViewModel {
    private func configureSearchImage(with products: [ProductModel]) {
        stateChangeHandler?(.snapshot(horizontal: handleSearchImageViewHorizontalListItem(products: products)))
    }
}

// MARK: data convert SearchImageViewItem extension
private extension SearchImageViewModel {
    private func handleSearchImageViewHorizontalListItem(products: [ProductModel]) -> [SearchImageViewItem] {
        let uniqueProducts = Dictionary(grouping: products, by: { $0.id })
            .compactMapValues { $0.first }
            .values
        return uniqueProducts.map { product in
            return .horizontalList(
                .init(id: product.id,
                      imageUrl: imageBaseURL + product.imageUrl,
                      isMan: product.isMan,
                      isTrend: product.isTrend,
                      originalPrice: product.originalPrice + " " + "TL",
                      productName: product.productName)
            )
        }
    }
}
