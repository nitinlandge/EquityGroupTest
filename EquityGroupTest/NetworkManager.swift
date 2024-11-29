//
//  NetworkManager.swift
//  EquityGroupTest
//
//  Created by administrator on 25/11/24.
//


import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://api.coinranking.com/v2/coins"
    private let apiKey = "coinrankingbf85979a3aefbcfa3785cdbb69551381807860ef14d89d46"

    func fetchCoins(page: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        let offset = page * 20
        var urlComponents = URLComponents(string: baseUrl)!
        urlComponents.queryItems = [
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.addValue(apiKey, forHTTPHeaderField: "x-access-token")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                print("@Response=> \(String.init(data: data, encoding: .utf8) ?? "")")
                let decodedResponse = try JSONDecoder().decode(CoinResponse.self, from: data)
                completion(.success(decodedResponse.data.coins))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

