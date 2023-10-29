//
//  ProductListViewModel.swift
//  ProductListing
//
//  Created by Moksh Marakana on 29/10/23.
//

import Foundation

class ProductListViewModel {
    var data: [ProductElement] = []

  
    
    func fetchProductData(apiUrl: String, completion: @escaping (Result<Data, Error>) -> Void) {

        if let encodedURLString = apiUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let encodedURL = URL(string: encodedURLString) {
            print("Encoded URL: \(encodedURL)")
            APIClient.shared.fetchData(from: encodedURL) { data, error in
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
            }
            
        } else {
            print("Failed to encode URL.")
        }
        
        
        
    }
    
}
