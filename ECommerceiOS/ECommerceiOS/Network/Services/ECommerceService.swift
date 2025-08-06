//
//  ECommerceService.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

enum ECommerceService {
    case getProducts(queryModel: ProductsQueryModel)
    case searchImage(request: ImageRequestModel)
    case searchText(request: TextRequestModel)
    case combination(request: ImageRequestModel)
    case searchTextAndImage(request: ImageAndTextRequestModel)
}

extension ECommerceService {
    enum EndPoint {
        static let getProducts = "/api/get_products"
        static let searchImage = "/api/search_by_image"
        static let searchText = "/api/search_by_text"
        static let combination = "/api/combination"
        static let searchTextAndImage = "/api/search_text_image"
    }
}

extension ECommerceService: TargetType {
    var baseURL: String {
        return "http://10.19.10.197:8002"
    }
    
    var path: String {
        switch self {
        case .getProducts:
            EndPoint.getProducts
        case .searchImage:
            EndPoint.searchImage
        case .searchText:
            EndPoint.searchText
        case .combination:
            EndPoint.combination
        case .searchTextAndImage:
            EndPoint.searchTextAndImage
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProducts:
                .get
        default:
                .post
        }
    }
    
    var task: NetworkTask {
        switch self {
        case .getProducts(let queryModel):
                .requestParameters(parameters: ["start": queryModel.start,
                                                "stop": queryModel.stop,
                                                "isMan": queryModel.isMan],
                                   encoding: EncodingType.queryString.encoding)
        case .searchImage(let request):
                .requestCodable(model: request,
                                encoding: EncodingType.jsonDefault.encoding)
        case .searchText(let request):
                .requestCodable(model: request,
                                encoding: EncodingType.jsonDefault.encoding)
        case .combination(let request):
                .requestCodable(model: request,
                                encoding: EncodingType.jsonDefault.encoding)
        case .searchTextAndImage(let request):
                .requestCodable(model: request,
                                encoding: EncodingType.jsonDefault.encoding)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
