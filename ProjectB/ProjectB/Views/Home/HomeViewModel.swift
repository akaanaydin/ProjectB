//
//  HomrViewModel.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//

import Foundation

final class HomeViewModel {
    
    // MARK: - Properties
    var onProductsListLoaded: (([Product]) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Fetch Initial Data
    func loadProductList(page: Int) {
        fetchProducts(page: page, categoryId: "10020", includeDocuments: true)
    }
    
    private func fetchProducts(page: Int, categoryId: String, includeDocuments: Bool) {
        Task {
            do {
                let productRequestResult: ProductsListRequest = try await NetworkManager.shared.request(
                    endpoint: ProductEndpoint.productList(page: page, categoryId: categoryId, includeDocuments: includeDocuments),
                    responseType: ProductsListRequest.self
                )
                
                DispatchQueue.main.async {
                    guard let result = productRequestResult.result?.productList else { return }
                    self.onProductsListLoaded?(result)
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}

