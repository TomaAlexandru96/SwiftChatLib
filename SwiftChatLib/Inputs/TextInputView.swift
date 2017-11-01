//
//  InputViewController.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class TextInputView: MessengerInput {
    
    @IBOutlet weak var inputField: UITextField!
    
    let type = InputType.TextInput
    
    override func setup(delegate: MessengerInputBehaviourDelegate) {
        super.setup(delegate: delegate)
        
        inputField.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onKeyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onKeyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
    }
    
    @objc func onKeyboardWillHide(_ notification: Notification) {
        behavoirDelegate.translateY(to: 0)
    }
    
    @objc func onKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            behavoirDelegate.translateY(to: -keyboardRectangle.height)
        }
    }
    
    override func hideKeyboard() {
        super.hideKeyboard()
        inputField.resignFirstResponder()
    }
    
}

extension TextInputView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let inputText = textField.text else {
            return false
        }
        behavoirDelegate.sendInput(message: inputText, from: type)
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
    
}
