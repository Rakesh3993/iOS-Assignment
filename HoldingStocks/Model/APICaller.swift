//
//  APICaller.swift
//  HoldingStocks
//
//  Created by Rakesh Kumar on 15/11/24.
//

import Foundation

enum ErrorConstants: Error {
    case ErrorInJsonDecoding
}

class APICaller {
    static let shared = APICaller()
    
    func fetchHoldingData(completion: @escaping (Result<[UserHolding], Error>) -> ()){
        guard let url = URL(string: Constants.url) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let safeData = data, error == nil else {
                print("Error fetching data")
                completion(.failure(error ?? ErrorConstants.ErrorInJsonDecoding))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(HoldingModel.self, from: safeData)
                completion(.success(result.data.userHolding))
            } catch {
                print(error)
                completion(.failure(ErrorConstants.ErrorInJsonDecoding))
            }
        }
        task.resume()
    }
}
