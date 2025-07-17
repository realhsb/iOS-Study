//
//  NetworkService.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/11/25.
//

import Foundation

class NetworkService {
  static let shared: NetworkService = NetworkService()
  
  func getHomeData() async throws -> HomeResponse {
    let urlString =  "https://my-json-server.typicode.com/JeaSungLee/JsonAPIFastCampus/db"
    guard let url = URL(string: urlString) else { throw URLError(.badURL) }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
    let decodeData = try JSONDecoder().decode(HomeResponse.self, from: data)
    return decodeData
  }
}
