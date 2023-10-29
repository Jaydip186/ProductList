//
//  ProductListRespose.swift
//  ProductListing
//
//  Created by Moksh Marakana on 29/10/23.
//

import Foundation


struct Product: Codable {
    let products: [ProductElement]?
    let total, skip, limit: Int?
}

// MARK: - ProductElement
struct ProductElement: Codable {
    let id: Int?
    let title, description: String?
    let price: Int?
    let discountPercentage, rating: Double?
    let stock: Int?
    let brand: String?
    let category: String?
    let thumbnail: String?
    let images: [String]?
}
