//
//  NetworkManager.swift
//  DeunDeun
//
//  Created by kim-wonhui on 2023/05/26.
//

import Foundation

enum FetchError: Error {
    case invalidURL
    case invalidID
    case invalidData
    case invalidStatusCode
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func requestData(url: String, parameters: [String:String]) async throws -> [String] {

        guard let url = URL(string: url) else {
            throw FetchError.invalidURL
        }

        let formDataString = parameters.map { "\($0)=\($1)" }.joined(separator: "&")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = formDataString.data(using: .utf8)
        request.httpBody = requestBody

        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw FetchError.invalidStatusCode
        }
        
        let cafeteriaResponse = try JSONDecoder().decode(CafeteriaResponse.self, from: data)

        var results = [String]()

        cafeteriaResponse.cafeteriaList.forEach { menu in
            if (31...35).contains(menu.type) {
                guard let eachMenu = menu.content else {
                    results.append("오늘은 운영하지 않아요 🥲")
                    return
                }
                results.append(eachMenu)
            }
        }

        return results
    }
}
