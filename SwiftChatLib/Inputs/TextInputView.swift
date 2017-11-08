//
//  InputViewController.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class TextInputView: MessengerInput {
    
    @IBOutlet weak var inputField: CustomTextInput!
    let type = InputType.TextInput
    
    override func setup(delegate: MessengerInputBehaviourDelegate) {
        super.setup(delegate: delegate)
        inputField.setup(delegate: delegate)
    }
    
    override func hideKeyboard() {
        super.hideKeyboard()
        inputField.resignFirstResponder()
    }
    
    @IBAction func pressedSend(_ sender: Any) {
        inputField.send()
    }
    
}
