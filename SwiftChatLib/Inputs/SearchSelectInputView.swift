//
//  SearchSelectInputView.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 08/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class SearchSelectInputView: MessengerInput {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var picker: CustomSelectInput!
    @IBOutlet weak var searchField: UITextField!
    fileprivate var allData: [(String, String)] = []
    fileprivate var beforeSearch: (_ query: String) -> Void = {_ in }
    
    override func loadData(data: [(String, String)]) {
        allData = data
        picker.loadData(data: data)
        DispatchQueue.main.async {
            self.picker.dataSource = self.picker
            self.picker.delegate = self.picker
            self.searchField.addTarget(self, action: #selector(self.startedTyping), for: .editingChanged)
        }
        DispatchQueue.main.async {
            self.sendButton.isEnabled = !self.allData.isEmpty
        }
    }
    
    override func setBeforeSearch(beforeSearch: @escaping (_ query: String) -> Void) {
        self.beforeSearch = beforeSearch
    }
    
    @IBAction func pressedSend(_ sender: UIButton) {
        behavoirDelegate.sendInput(message: TextMessage(content: picker.getSelected().1, from: .Me))
    }
    
    @objc func startedTyping() {
        guard let query = searchField.text else {
            return
        }
        
        beforeSearch(query)
        
        var newData: [(String, String)] = []
        allData.forEach({
            if $0.0.hasPrefix(query) {
                newData.append($0)
            }
        })
        picker.loadData(data: newData)
        sendButton.isEnabled = !newData.isEmpty
    }
}

