//
//  ViewController.swift
//  CryptoApp
//
//  Created by Denis Onofras on 10.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    
}

//MARK: - UIPickerViewDelegate
extension   ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currency)
        currencyLabel.text = currency
        rateLabel.text = "..."
    }
}
//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func didUpdateData(_ coinManager: CoinManager, rate: String) {
        DispatchQueue.main.async {
            self.rateLabel.text = rate
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

