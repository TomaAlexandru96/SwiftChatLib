//
//  MessengerInputDelegate.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class MessengerInput: UIView {
    
    var behavoirDelegate: MessengerInputBehaviourDelegate!
    
    func setup(delegate: MessengerInputBehaviourDelegate) {
        guard let _ = superview else {
            fatalError("Should not be null")
        }
        
        behavoirDelegate = delegate
    }
    
    func hideKeyboard() {}
    
}
