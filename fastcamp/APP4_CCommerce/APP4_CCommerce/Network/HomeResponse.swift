//
//  HomeResponse.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/11/25.
//

import Foundation

struct HomeResponse: Decodable {
  let banners: [Banner]
  let horizontalProducts: [Product]
  let verticalProducts: [Product]
  let themes: [Banner]
}

// MARK: - Banner
struct Banner: Decodable {
  let id: Int
  let imageUrl: String
}

// MARK: - Product
struct Product: Decodable {
  let id: Int
  let imageUrl: String
  let title: String
  let discount: String
  let originalPrice: Int
  let discountPrice: Int
}

