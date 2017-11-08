//
//  SelectInputView.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 08/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class SelectInputView: MessengerInput {
    
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
}

extension SelectInputView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
}

extension SelectInputView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = row
    }
}
