//
//  SelectInputView.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 08/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class SelectInputView: MessengerInput {
    
    @IBOutlet weak var picker: CustomSelectInput!
    
    override func loadData(data: [(String, String)]) {
        picker.loadData(data: data)
        DispatchQueue.main.async {
            self.picker.dataSource = self.picker
            self.picker.delegate = self.picker
        }
    }
    
    @IBAction func pressedSend(_ sender: UIButton) {
        behavoirDelegate.sendInput(message: TextMessage(content: picker.getSelected().1, from: .Me))
    }
}
