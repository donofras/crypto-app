//
//  ViewController.swift
//  CryptoApp
//
//  Created by Denis Onofras on 10.03.2021.
//

import UIKit
import Charts
import TinyConstraints

class ViewController: UIViewController {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var chartView: UIView!
    
    lazy var lineChartView: LineChartView = {
        let lineChart = LineChartView()
        lineChart.backgroundColor = UIColor(named: "Background Color")
        
        return lineChart
    }()
    
    var coinManager = CoinManager()
    
    let dataArray = [1,5,7,8,0,3,5,8,5,7,5,2,5,7,9,4,2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: chartView)
        lineChartView.height(to: chartView)
        
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.enabled = false
        
        setData(dataArray)
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currency = "EUR"
        currencyLabel.text = currency
        coinManager.getCoinPrice(for: currency)
    }
    
    func setData(_ array: [Int]) {
        var yValue = [ChartDataEntry]()
        
        for (index,data) in array.enumerated() {
            let value = ChartDataEntry(x: Double(index), y: Double(data))
            yValue.append(value)
        }
        
        let dataSet = LineChartDataSet(entries: yValue, label: currencyLabel.text!)
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 3
        dataSet.setColor(UIColor(named: "Text Color")!, alpha: 1.0)
        
        let chartData = LineChartData(dataSet: dataSet)
        chartData.setDrawValues(false)
        lineChartView.data = chartData;
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

