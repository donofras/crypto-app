//
//  CoinManager.swift
//  CryptoApp
//
//  Created by Denis Onofras on 13.03.2021.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateData(_ coinManager: CoinManager, rate: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "680EA28E-8680-4B1A-A395-B29E85C651F4"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RUB","SEK","SGD","USD","ZAR"]
    
    let cryptoCurrencyArray = ["BTC","ETH"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data)  {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoindData.self, from: coinData)
            let rate = decodedData.rate
            let rateInString = String(format: "%.2f", rate)
            self.delegate?.didUpdateData(self, rate: rateInString)
        } catch {
            self.delegate?.didFailWithError(error: error)
        }
    }
}
