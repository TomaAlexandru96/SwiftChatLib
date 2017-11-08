//
//  TwoButtonsInputView.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 08/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class TwoButtonsInputView: MessengerInput {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    fileprivate var data: [(String, String)] = []
    
    @IBAction func leftPressed(_ sender: Any) {
        behavoirDelegate.sendInput(message: TextMessage(content: data[0].1, from: .Me))
    }
    
    @IBAction func rightPressed(_ sender: Any) {
        behavoirDelegate.sendInput(message: TextMessage(content: data[1].1, from: .Me))
    }
    
    override func loadData(data: [(String, String)]) {
        super.loadData(data: data)
        self.data = data
        DispatchQueue.main.async {
            self.leftButton.setTitle(data[0].0, for: .normal)
            self.rightButton.setTitle(data[1].0, for: .normal)
        }
    }
}
