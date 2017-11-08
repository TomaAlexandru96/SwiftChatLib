//
//  ViewController.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

var AILogicForm: AILogic!

class ChatViewController: UIViewController {
    
    @IBOutlet var searchSelectInputView: SearchSelectInputView!
    @IBOutlet var selectInputView: SelectInputView!
    @IBOutlet var textInputElement: TextInputView!
    @IBOutlet weak var messengerInputView: UIView!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    
    var messengerView: MessengerCollectionViewController!
    var elements: [InputType: MessengerInput] = [:]
    fileprivate var AI: AILogic!
    fileprivate var originalViewHeight: CGFloat = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalViewHeight = view.frame.height
        initMessengerView()
        initMessengerInputView()
        initAI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let vc = segue.destination as? MessengerCollectionViewController,
            segue.identifier == "ChatMessengerSegue" {
            self.messengerView = vc
        }
    }
    
    fileprivate func initMessengerView() {
        messengerView.behaviorDelegate = self
    }
    
    fileprivate func initMessengerInputView() {
        elements = [
            .TextInput: textInputElement,
            .SelectInput: selectInputView,
            .SearchSelectInput: searchSelectInputView
        ]
        _ = changeInputView(to: .TextInput)
    }
    
    fileprivate func initAI() {
        AI = AILogicForm
        AI.setChat(chat: self)
        AI.startAI()
    }
    
    func changeInputView(to inputViewType: InputType) -> MessengerInput? {
        guard let inputView = elements[inputViewType] else {
            DispatchQueue.main.async {
                self.messengerInputView.subviews.forEach { $0.removeFromSuperview() }
            }
            return nil
        }
        DispatchQueue.main.async {
            self.messengerInputView.addSubview(inputView)
            inputView.setup(delegate: self)
            inputView.frame = CGRect(x: inputView.frame.origin.x, y: inputView.frame.origin.y, width: self.messengerInputView.frame.width, height: inputView.frame.height)
            self.inputViewHeightConstraint.constant = inputView.frame.height
        }
        return inputView
    }
    
    func restart() {
        messengerView.reset()
    }
    
}

extension ChatViewController: MessengerBehavoirDelegate {
    
    func deletedLastMessageFromMe() {
        messengerView.deleteLastCells(nr: AI.deleteLastAnswer())
    }
    
    func hideKeyboard() {
        messengerInputView.subviews.forEach({
            guard let messengerInput = $0 as? MessengerInput else {
                return
            }
            messengerInput.hideKeyboard()
        })
    }
    
    func receivedMessage(message: GenericMessage) {
        if (message.from == .Me) {
            AI.recordInput(message: message)
        }
    }
    
}

extension ChatViewController: MessengerInputBehaviourDelegate {
    
    func keyboardDisapeared() {
        view.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: originalViewHeight))
    }
    
    func sendInput(message: GenericMessage) {
        messengerView.sendMessage(message: message)
    }
    
    func keyboardAppeared(keyboardHeight: CGFloat) {
        let newHeight = originalViewHeight - keyboardHeight
        view.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: newHeight))
    }
    
}
