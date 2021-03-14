//
//  CoinManager.swift
//  CryptoApp
//
//  Created by Denis Onofras on 13.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CoinManagerDelegate {
    func didUpdateData(_ coinManager: CoinManager, rate: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "680EA28E-8680-4B1A-A395-B29E85C651F4"
    
    let currencyArray = ["EUR","USD","GBP","AUD", "BRL","CAD","CNY","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RUB","SEK","SGD","ZAR"]
    
    let cryptoCurrencyArray = ["BTC","ETH"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        print(urlString)
        AF.request(urlString, method: .get).responseJSON { (response) in
            if let safeData = response.data {
                let dataJSON : JSON = JSON(safeData)
                let rate = dataJSON["rate"].doubleValue
                let rateInString = String(format: "%.2f", rate)
                self.delegate?.didUpdateData(self, rate: rateInString)
            }
        }
    }
}
