//
//  BaseAPI.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 1.08.2025.
//

import Alamofire

class BaseAPI<T:TargetType> {
    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completionHandler:@escaping (Result<M, NSError>)-> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)
        AF.request(target.baseURL + target.path,
                   method: method,
                   parameters: parameters.0,
                   encoding: parameters.1,
                   headers: headers)
        .responseDecodable(of: M.self) { response in
            debugPrint(response)
            
            guard let statusCode = response.response?.statusCode else {
                print("StatusCode not found")
                completionHandler(.failure(NSError(domain: "NoStatusCode", code: -1, userInfo: nil)))
                return
            }
            
            if statusCode == 200 {
                switch response.result {
                case .success(let responseObj):
                    completionHandler(.success(responseObj))
                case .failure(let error):
                    print("Decoding error: \(error.localizedDescription)")
                    completionHandler(.failure(error as NSError))
                }
            } else {
                print("Error statusCode is \(statusCode)")
                completionHandler(.failure(NSError(domain: "InvalidStatusCode", code: statusCode, userInfo: nil)))
            }
        }
    }
    
    private func buildParams(task: NetworkTask) -> ([String: Any], ParameterEncoding){
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        case .requestCodable(model: let model, encoding: let encoding):
            if let encodedParams = encodeModelToDictionary(model) {
                return (encodedParams, encoding)
            } else {
                return ([:], encoding) // Hata durumunda boş bir dictionary döndürülebilir
            }
        }
    }
    
    func encodeModelToDictionary<C: Codable>(_ model: C) -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(model)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject as? [String: Any]
        } catch {
            print("Error encoding model: \(error)")
            return nil
        }
    }
}
