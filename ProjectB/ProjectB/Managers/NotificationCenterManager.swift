//
//  NotificationCenterManager.swift
//  ProjectB
//
//  Created by Scissors on 18.12.2024.
//


import Foundation

final class NotificationCenterManager {
    private let notificationCenter = NotificationCenter.default
    
    func postFavoriteStatusChanged(productId: Int) {
        notificationCenter.post(
            name: .favoriteStatusChanged,
            object: nil,
            userInfo: ["productId": productId]
        )
    }
    
    func addFavoriteStatusObserver(
        observer: Any,
        selector: Selector
    ) {
        notificationCenter.addObserver(
            observer,
            selector: selector,
            name: .favoriteStatusChanged,
            object: nil
        )
    }
    
    func removeObserver(_ observer: Any) {
        notificationCenter.removeObserver(observer)
    }
}


