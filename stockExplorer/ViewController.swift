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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var companyPicker: UIPickerView!
    @IBOutlet weak var companyName: UILabel!
    private let companies: [String: String] = ["Apple": "APPL", "Microsoft": "MSFT", "Google": "GOOG", "Amazon": "AMZN", "Facebook": "FB"]
    
    private func parseQuote(data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with:data)
            
            guard
                let json = jsonObject as? [String: Any],
                let companyName = json["companyName"] as? String
            else {
                print("Invalid JSON format")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName)
            }
        } catch {
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String) {
        self.activityIndicator.stopAnimating()
        self.companyName.text = companyName
    }
    
    private func requestQuote(for symbol: String) {
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(symbol)/quote")!
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
        self.activityIndicator.startAnimating()
        self.requestQuote(for: "APPL")
    }


}

