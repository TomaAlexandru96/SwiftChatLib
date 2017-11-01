//
//  ViewController.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet var textInputElement: TextInputView!
    @IBOutlet weak var messengerView: MessengerCollectionView!
    @IBOutlet weak var messengerInputView: UIView!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    
    var elements: [InputType: MessengerInput] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMessengerView()
        initMessengerInputView()
    }
    
    func initMessengerView() {
        messengerView.behavoirdDelegate = self
    }
    
    func initMessengerInputView() {
        elements = [
            .TextInput: textInputElement
        ]
        changeInputView(to: .TextInput)
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
    
}

extension ChatViewController: MessengerInputBehaviourDelegate {
    
    func sendInput(message: GenericMessage) {
        messengerView.sendMessage(message: message)
    }
    
    func translateY(to: CGFloat) {
        view.frame.origin.y = to
    }
    
}
