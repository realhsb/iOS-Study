//
//  NetworkService.swift
//  APP4_CCommerce
//
//  Created by Soop on 7/11/25.
//

import Foundation

class NetworkService {
    static let shared: NetworkService = NetworkService()
     
    private let hostURL = "https://my-json-server.typicode.com/JeaSungLee/JsonAPIFastCampus/"
    
    private func createURL(withPath path: String) throws -> URL {
        let urlString: String = "\(hostURL)\(path)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) } // throw랑 throws 차이가 뭐지
        return url
    }
    
    private func fetchData(form url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
        return data
    }
    
    func getHomeData() async throws -> HomeResponse {
        let url = try createURL(withPath: "/db")
        let data = try await fetchData(form: url)
        let decodeData = try JSONDecoder().decode(HomeResponse.self, from: data)
        return decodeData
    }
}
