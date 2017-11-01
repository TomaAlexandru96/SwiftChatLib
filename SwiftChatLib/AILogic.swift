//
//  AILogic.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import Foundation

class AILogic {
    
    fileprivate let chat: ChatViewController
    
    init(chat: ChatViewController) {
        self.chat = chat
    }
    
    func start() {
        chat.sendInput(message: TextMessage(content: "Hello", from: .Other))
    }
}
