//
//  HoldingModel.swift
//  HoldingStocks
//
//  Created by Rakesh Kumar on 15/11/24.
//

import Foundation

struct HoldingModel: Codable {
    let data: HoldingData
}

struct HoldingData: Codable {
    let userHolding: [UserHolding]
}

struct UserHolding: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
}
