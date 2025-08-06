//
//  ImageURLToBase64.swift
//  ECommerceiOS
//
//  Created by OmerSarlavuk on 5.08.2025.
//

import UIKit

public class ImageURLToBase64 {
    static func convertImageURLToBase64(urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let base64String = imageData.base64EncodedString()
                completion(base64String)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
