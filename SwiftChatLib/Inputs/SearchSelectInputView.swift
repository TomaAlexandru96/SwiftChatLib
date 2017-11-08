//
//  SearchSelectInputView.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 08/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class SearchSelectInputView: MessengerInput {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    fileprivate var data: [(String, String)] = []
    fileprivate var selected: Int = -1
    
    override func loadData(data: [(String, String)]) {
        self.data = data
        DispatchQueue.main.async {
            self.picker.dataSource = self
            self.picker.delegate = self
        }
    }
    
    @IBAction func pressedSend(_ sender: UIButton) {
        behavoirDelegate.sendInput(message: TextMessage(content: data[selected].1, from: .Me))
    }
    
    @IBAction func startTyping(_ sender: Any) {
    }
}

extension SearchSelectInputView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension SearchSelectInputView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = row
    }
}

