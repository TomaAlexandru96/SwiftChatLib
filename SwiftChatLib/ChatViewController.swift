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
    
    @IBOutlet var textInputElement: TextInputView!
    @IBOutlet weak var messengerInputView: UIView!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    
    var messengerView: MessengerCollectionViewController!
    var elements: [InputType: MessengerInput] = [:]
    fileprivate var AI: AILogic!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func initMessengerView() {
        messengerView.behaviorDelegate = self
    }
    
    func initMessengerInputView() {
        elements = [
            .TextInput: textInputElement
        ]
        changeInputView(to: .TextInput)
    }
    
    func initAI() {
        AILogicForm.setChat(chat: self)
        AILogicForm.startAI()
    }
    
    func changeInputView(to inputViewType: InputType) {
        guard let inputView = elements[inputViewType] else {
            fatalError("Should be able to find the enum in the dictionary")
        }
        messengerInputView.subviews.forEach { $0.removeFromSuperview() }
        messengerInputView.addSubview(inputView)
        inputView.setup(delegate: self)
        inputViewHeightConstraint.constant = inputView.frame.height
    }
    
}

extension ChatViewController: MessengerBehavoirDelegate {
    
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
            AILogicForm.recordInput(message: message)
        }
    }
    
}

extension ChatViewController: MessengerInputBehaviourDelegate {
    
    func sendInput(message: GenericMessage) {
        messengerView.sendMessage(message: message)
    }
    
    func translateY(to: CGFloat) {
        view.frame.origin.y = to
    }
    
}
