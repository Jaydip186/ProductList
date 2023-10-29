//
//  APIClient.swift
//  ProductListing
//
//  Created by Moksh Marakana on 29/10/23.
//

import Foundation


class APIClient {
    static let shared = APIClient()
    
    private init() { }
    
    func fetchData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }.resume()
    }
}
