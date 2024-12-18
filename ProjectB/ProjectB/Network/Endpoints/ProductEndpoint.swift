//
//  ProductEndpoint.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//


// MARK: - Product Endpoints
enum ProductEndpoint: Endpoint {
    case productList(page: Int, categoryId: String, includeDocuments: Bool)
    case productDetail(productId: String)
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var baseURL: String {
        "https://www.beymen.com/Mobile2/api"
    }
    
    var path: String {
        switch self {
        case .productList:
            return "/mbproduct/list"
        case .productDetail:
            return "/mbproduct/product"
        }
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var queryParameters: [String: Any]? {
        switch self {
        case .productList(let page, let categoryId, let includeDocuments):
            return [
                "siralama": "akillisiralama",
                "sayfa": "\(page)",
                "categoryId": categoryId,
                "includeDocuments": "\(includeDocuments)"
            ]
        case .productDetail(let productId):
            return [
                "productid": productId
            ]
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
