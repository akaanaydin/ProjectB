//
//  UserDefaultsManager.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//


import Foundation

class UserDefaultsManager {
    
    private let productIdsKey = "favoriteProducts"
    private let defaults = UserDefaults.standard

    func getProductIds() -> [Int] {
        return defaults.array(forKey: productIdsKey) as? [Int] ?? []
    }

    func addProductId(_ productId: Int) {
        var currentIds = getProductIds()
        if !currentIds.contains(productId) {
            currentIds.append(productId)
            defaults.set(currentIds, forKey: productIdsKey)
        }
    }

    func removeProductId(_ productId: Int) {
        var currentIds = getProductIds()
        if let index = currentIds.firstIndex(of: productId) {
            currentIds.remove(at: index)
            defaults.set(currentIds, forKey: productIdsKey)
        }
    }
    
    func containsProductId(_ productId: Int) -> Bool {
        return getProductIds().contains(productId)
    }

    func clearAllProductIds() {
        defaults.removeObject(forKey: productIdsKey)
    }
}
