//
//  ProductFeedViewModeling.swift
//  ShopSavvy
//
//  Created by Mo Ahmad on 15/04/2023.
//

import Foundation

protocol ProductFeedViewModeling {
    var isLoading: Bool { get }
    var title: String { get }
    var products: [Product] { get }
    var error: Error? { get set }

    func loadFeed(isPullToRefresh: Bool)
    func loadMoreContentIfNeeded(currentItem: Product?)
}
