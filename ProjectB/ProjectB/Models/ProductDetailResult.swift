//
//  ProductDetailResult.swift
//  ProjectB
//
//  Created by Scissors on 17.12.2024.
//
import Foundation

// MARK: - ProductDetailResult
struct ProductDetailRequest: Codable {
    let success: Bool?
    let result: ProductDetail?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case result = "Result"
    }
}

// MARK: - Result
struct ProductDetail: Codable {
    let productID: Int?
    let displayName: String?
    let description: Description?
    let brandName, actualPriceText: String?
    let images: [ResultImage]?

    enum CodingKeys: String, CodingKey {
        case productID = "ProductId"
        case displayName = "DisplayName"
        case description = "Description"
        case brandName = "BrandName"
        case actualPriceText = "ActualPriceText"
        case images = "Images"
    }
}

// MARK: - Description
struct Description: Codable {
    let ozellikler: String?

    enum CodingKeys: String, CodingKey {
        case ozellikler = "Özellikler :"
    }
}

// MARK: - ResultImage
struct ResultImage: Codable {
    let images: [ImageImage]?

    enum CodingKeys: String, CodingKey {
        case images = "Images"
    }
}

// MARK: - ImageImage
struct ImageImage: Codable {
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "ImageUrl"
    }
}
