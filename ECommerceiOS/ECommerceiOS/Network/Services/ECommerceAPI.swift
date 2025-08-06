//
//  ECommerceAPI.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import Foundation

protocol ECommerceAPIProtocol {
    func getProducts(queryModel: ProductsQueryModel, completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void)
    func searchImage(request: ImageRequestModel, completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void)
    func searchText(request: TextRequestModel, completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void)
    func combination(request: ImageRequestModel, completionHandler: @escaping (Result<BaseResponseModel<CombinationModel>, NSError>) -> Void)
    func searchTextAndImage(request: ImageAndTextRequestModel, completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void)
}

class ECommerceAPI: BaseAPI<ECommerceService>, ECommerceAPIProtocol {
    func getProducts(queryModel: ProductsQueryModel,
                     completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void) {
        fetchData(target: .getProducts(queryModel: queryModel),
                  responseClass: BaseResponseModel<[ProductModel]>.self) { result in
            completionHandler(result)
        }
    }
    
    func searchImage(request: ImageRequestModel, completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void) {
        fetchData(target: .searchImage(request: request),
                  responseClass: BaseResponseModel<[ProductModel]>.self) { result in
            completionHandler(result)
        }
    }
    
    func searchText(request: TextRequestModel, completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void) {
        fetchData(target: .searchText(request: request),
                  responseClass: BaseResponseModel<[ProductModel]>.self) { result in
            completionHandler(result)
        }
    }
    
    func combination(request: ImageRequestModel, completionHandler: @escaping (Result<BaseResponseModel<CombinationModel>, NSError>) -> Void) {
        fetchData(target: .combination(request: request),
                  responseClass: BaseResponseModel<CombinationModel>.self) { result in
            completionHandler(result)
        }
    }
    
    func searchTextAndImage(request: ImageAndTextRequestModel, completionHandler: @escaping (Result<BaseResponseModel<[ProductModel]>, NSError>) -> Void) {
        fetchData(target: .searchTextAndImage(request: request),
                  responseClass: BaseResponseModel<[ProductModel]>.self) { result in
            completionHandler(result)
        }
    }
}
