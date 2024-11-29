//
//  CoinResponse.swift
//  EquityGroupTest
//
//  Created by administrator on 25/11/24.
//


struct CoinResponse: Codable {
    let data: CoinData
}

struct CoinData: Codable {
    let coins: [Coin]
}

//struct Coin: Codable {
//    let uuid: String
//    let name: String
//    let price: String
//    let change: String
//    let iconUrl: String
//}
//
//import Foundation

struct Coin: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let color: String?
    let iconUrl: String
    let marketCap: String
    let price: String
    let listedAt: Int
    let tier: Int
    let change: String
    let rank: Int
    let sparkline: [String?]
    let lowVolume: Bool
    let coinrankingUrl: String
    let volume24h: String
    let btcPrice: String
    let contractAddresses: [String]
    let description: String?
    let supply: Supply?
    let allTimeHigh: AllTimeHigh?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case symbol
        case name
        case color
        case iconUrl
        case marketCap
        case price
        case listedAt
        case tier
        case change
        case rank
        case sparkline
        case lowVolume
        case coinrankingUrl
        case volume24h = "24hVolume"
        case btcPrice
        case contractAddresses
        case description
        case supply
        case allTimeHigh
    }
}

struct Supply: Codable {
    let circulating: String?
    let total: String?
    let max: String?
}

struct AllTimeHigh: Codable {
    let price: String
    let timestamp: Int
}
