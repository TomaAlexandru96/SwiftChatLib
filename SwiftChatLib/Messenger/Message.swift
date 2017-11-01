//
//  Message.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import Foundation

enum MessageSource {
    case Me
    case AI
}

class GenericMessage {
    var from: MessageSource
    
    init(from: MessageSource) {
        self.from = from
    }
}

class Message<T: SupportedData>: GenericMessage {
    var content: T
    
    init(content: T, from: MessageSource) {
        self.content = content
        super.init(from: from)
    }
}

class TextMessage: Message<String> {
    
}

protocol SupportedData {}
extension String: SupportedData {}
