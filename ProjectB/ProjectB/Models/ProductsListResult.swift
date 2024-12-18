//
//  ProductsListResult.swift
//  ProjectB
//
//  Created by Scissors on 17.12.2024.
//

import Foundation

// MARK: - ProductsListResult
struct ProductsListRequest: Codable {
    let success: Bool?
    let result: ProductsListResult?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case result = "Result"
    }
}

// MARK: - Result
struct ProductsListResult: Codable {
    let productList: [Product]?

    enum CodingKeys: String, CodingKey {
        case productList = "ProductList"
    }
}

// MARK: - ProductList
struct Product: Codable {
    let productID: Int?
    let displayName: String?
    let brandName: String?
    let imageURL: String?
    let imageUrls: [String]?
    let price: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "ProductId"
        case displayName = "DisplayName"
        case brandName = "BrandName"
        case imageURL = "ImageUrl"
        case imageUrls = "ImageUrls"
        case price = "Price"
    }
}
