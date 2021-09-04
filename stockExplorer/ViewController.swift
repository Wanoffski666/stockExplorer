//
//  ViewController.swift
//  stockExplorer
//
//  Created by Дане4ка on 04.09.2021.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.activityIndicator.startAnimating()
        let selectedSymbol = Array(self.companies.values)[row]
        self.requestQuote(for: selectedSymbol)
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyPicker: UIPickerView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companySymbol: UILabel!
    @IBOutlet weak var companyPrice: UILabel!
    @IBOutlet weak var companyPriceChange: UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    
    private let companies: [String: String] = ["Apple": "APPL", "Microsoft": "MSFT", "Google": "GOOG", "Amazon": "AMZN", "Facebook": "FB"]
    
    private func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with:data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else {
                
                print("Invalid JSON format")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName, symbol: companySymbol, price: price, priceChange: priceChange)
            }
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double) {
        self.activityIndicator.stopAnimating()
        self.companyName.text = companyName
        self.companySymbol.text = symbol
        self.companyPrice.text = "\(price)"
        if priceChange > 0 {
            self.companyPriceChange.textColor = UIColor.green
            self.companyPriceChange.text = "\(priceChange)" + "↑"
        } else {
            self.companyPriceChange.textColor = UIColor.red
            self.companyPriceChange.text = "\(priceChange)" + "↓"
        }
    }
    
    private func requestQuoteUpdate() {
        self.activityIndicator.startAnimating()
        self.companyName.text = "-"
        self.companySymbol.text = "-"
        self.companyPrice.text = "-"
        self.companyPriceChange.text = "-"
        self.companyPriceChange.textColor = UIColor.black
        let selectedRow = self.companyPicker.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        self.requestQuote(for: selectedSymbol)
        
    }
    
    private func requestQuote(for symbol: String) {
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?&token=pk_52aa8ca08ec045a7b151e545fb2ea3d9")!
        let dataTask = URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
            else {
                print("Network error")
                return
            }
            self.parseQuote(data: data)
        }
        dataTask.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.companyPicker.dataSource = self
        self.companyPicker.delegate = self
        self.activityIndicator.hidesWhenStopped = true
        self.requestQuoteUpdate()
    }


}

