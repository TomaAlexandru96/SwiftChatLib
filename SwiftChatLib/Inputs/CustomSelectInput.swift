//
//  CustomSelectInput.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 08/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class CustomSelectInput: UIPickerView {
    fileprivate var data: [(String, String)] = []
    fileprivate var selected: Int = 0
    
    func loadData(data: [(String, String)]) {
        self.data = data
        DispatchQueue.main.async {
            self.reloadAllComponents()
        }
    }
    
    func getSelected() -> (String, String) {
        return data[selected]
    }
}

extension CustomSelectInput: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension CustomSelectInput: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = row
    }
}
