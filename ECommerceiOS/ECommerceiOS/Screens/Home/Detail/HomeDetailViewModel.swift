//
//  HomeDetailViewModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 4.08.2025.
//

import Foundation

class HomeDetailViewModel: ViewModel {
    var stateChangeHandler: Callback<HomeDetailViewState>?
    
    private var api = ECommerceAPI()
    
    private let imageBaseURL = "https://cdn.dsmcdn.com"
    private var topProductModel: ProductModel?
    
    func start(with data: Any?) {
        guard let data = data as? ProductModel else {
            return
        }
        
        topProductModel = data
        
        ImageURLToBase64.convertImageURLToBase64(urlString: data.imageUrl) { [ weak self ] base64 in
            DispatchQueue.main.async {
                guard let self,
                      let base64 = base64 else {
                    return
                }
                self.searchTextAndImage(to: base64, to: data.productName)
            }
        }
    }
}

// MARK: network extension
private extension HomeDetailViewModel {
    private func searchTextAndImage(to image: String,
                                    to text: String) {
        stateChangeHandler?(.base(.startLoadingIndicator))
        
        let requestModel: ImageAndTextRequestModel = ImageAndTextRequestModel(image: image,
                                                                              text: text)
        
        api.searchTextAndImage(request: requestModel) { [ weak self ] result in
            guard let self else {
                return
            }
            self.stateChangeHandler?(.base(.removeLoadingIndicator))
            
            switch result {
            case .success(let response):
                if response.code == Constant.RESPONSE_SUCCESS_CODE {
                    self.configureSearchTextAndImage(with: response.data)
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
private extension HomeDetailViewModel {
    private func configureSearchTextAndImage(with products: [ProductModel]) {
        stateChangeHandler?(.snapshot(top: handleHomeDetailTopListItem(),
                                      horizontal: handleHomeDetailHorizontalListItem(products: products)))
    }
}

// MARK: data convert HomeListItem extension
private extension HomeDetailViewModel {
    private func handleHomeDetailTopListItem() -> [HomeDetailViewItem] {
        guard let topProductModel = topProductModel else {
            return []
        }
        return [HomeDetailViewItem.top(topProductModel)]
    }
    
    private func handleHomeDetailHorizontalListItem(products: [ProductModel]) -> [HomeDetailViewItem] {
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
