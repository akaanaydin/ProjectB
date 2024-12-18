//
//  HomeViewModel.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//

import Foundation

final class DetailViewModel {
    
    // MARK: - Properties
    var onProductsDetailLoaded: ((ProductDetail) -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Fetch Data
    func loadProductDetail(productID: Int) {
        fetchProductDetail(productID: productID)
    }
    
    private func fetchProductDetail(productID: Int) {
        Task {
            do {
                let productRequestResult: ProductDetailRequest = try await NetworkManager.shared.request(
                    endpoint: ProductEndpoint.productDetail(productId: "\(productID)"),
                    responseType: ProductDetailRequest.self
                )
                
                DispatchQueue.main.async {
                    guard let result = productRequestResult.result else { return }
                    self.onProductsDetailLoaded?(result)
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
