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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.companyPicker.dataSource = self
        self.companyPicker.delegate = self
        
    }


}

