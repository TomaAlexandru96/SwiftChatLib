//
//  MessengerInputBehaviourDelegate.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

protocol MessengerInputBehaviourDelegate {
    func translateY(to: CGFloat)
    func sendInput<T>(message: T, from: InputType)
}
