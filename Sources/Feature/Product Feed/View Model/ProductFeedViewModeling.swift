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

    func loadFeed()
    func loadMoreContentIfNeeded(currentItem: Product?)
}
