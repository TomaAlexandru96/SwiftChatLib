//
//  CustomTextInput.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 08/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class CustomTextInput: UITextField {
    
    let type = InputType.TextInput
    var behavoirDelegate: MessengerInputBehaviourDelegate!
    
    func setup(delegate: MessengerInputBehaviourDelegate) {
        self.behavoirDelegate = delegate
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
        behavoirDelegate.keyboardDisapeared()
    }
    
    @objc func onKeyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            behavoirDelegate.keyboardAppeared(keyboardHeight: keyboardRectangle.height)
        }
    }
    
    func send() {
        guard let text = text, text != "" else {
            return
        }
        behavoirDelegate.sendInput(message: TextMessage(content: text, from: .Me))
        self.text = ""
    }
}
