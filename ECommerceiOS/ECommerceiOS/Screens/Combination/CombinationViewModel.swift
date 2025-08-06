//
//  CombinationViewModel.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

import UIKit

class CombinationViewModel: ViewModel {
    var stateChangeHandler: Callback<CombinationViewState>?
    
    private var api = ECommerceAPI()
    
    private let imageBaseURL = "https://cdn.dsmcdn.com"
    
    func start(with data: Any?) {
        guard let imageUrl = data as? String else {
            return
        }
        
        ImageURLToBase64.convertImageURLToBase64(urlString: imageUrl) { [ weak self ] base64 in
            DispatchQueue.main.async {
                guard let self,
                      let base64 = base64 else {
                    return
                }
                self.combination(to: base64)
            }
        }
    }
}

// MARK: network extension
private extension CombinationViewModel {
    private func combination(to base64: String) {
        stateChangeHandler?(.base(.startLoadingIndicator))
        
        let request: ImageRequestModel = ImageRequestModel(image: base64)
        
        api.combination(request: request) { [ weak self ] result in
            guard let self else {
                return
            }
            self.stateChangeHandler?(.base(.removeLoadingIndicator))
            
            switch result {
            case .success(let response):
                if response.code == Constant.RESPONSE_SUCCESS_CODE {
                    self.configureCombination(with: response.data)
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
private extension CombinationViewModel {
    private func configureCombination(with combinationModel: CombinationModel) {
        stateChangeHandler?(.snapshot(handleCombinationViewItem(with: combinationModel)))
    }
}

// MARK: data convert CombinationViewItem extension
private extension CombinationViewModel {
    private func handleCombinationViewItem(with combinationModel: CombinationModel) -> [CombinationViewItem] {
        var items: [CombinationViewItem] = []
        
        combinationModel.combinations.enumerated().forEach { index, combination in
            let occasion = combinationModel.occasions[index]
            
            let topProduct = ProductModel(id: combination.topProduct.id,
                                          imageUrl: imageBaseURL + combination.topProduct.imageUrl,
                                          isMan: combination.topProduct.isMan,
                                          isTrend: combination.topProduct.isTrend,
                                          originalPrice: combination.topProduct.originalPrice + " " + "TL",
                                          productName: combination.topProduct.productName)
            let bottomProduct = ProductModel(id: combination.bottomProduct.id,
                                             imageUrl: imageBaseURL + combination.bottomProduct.imageUrl,
                                             isMan: combination.bottomProduct.isMan,
                                             isTrend: combination.bottomProduct.isTrend,
                                             originalPrice: combination.bottomProduct.originalPrice + " " + "TL",
                                             productName: combination.bottomProduct.productName)
            
            items.append(
                .list(
                    .init(title: occasion,
                          topProduct: topProduct,
                          bottomProduct: bottomProduct)
                )
            )
        }
        
        return items
    }
}
