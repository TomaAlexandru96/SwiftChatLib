//
//  MessengerInputBehaviourDelegate.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

protocol MessengerInputBehaviourDelegate {
    func keyboardAppeared(keyboardHeight: CGFloat)
    func keyboardDisapeared()
    func sendInput(message: GenericMessage)
}
