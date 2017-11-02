//
//  AILogic.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import Foundation

class AILogic {
    
    fileprivate var chat: ChatViewController!
    fileprivate let WAIT_TIME_SHORT: UInt32 = 500000
    fileprivate let WAIT_TIME_LONG: UInt32 = 1000000
    fileprivate var inputSema: semaphore_t = semaphore_t(0)
    fileprivate var inputMessage: GenericMessage!
    
    func setChat(chat: ChatViewController) {
        self.chat = chat
    }
    
    func recordInput(message: GenericMessage) {
        inputMessage = message
        semaphore_signal(inputSema)
    }
    
    fileprivate func waitForInput() {
        semaphore_wait(inputSema)
    }
    
    // to be overriden by children
    fileprivate func setup() {}
    func start() {}
    func restart() {}
    
}

class QuoteAI: AILogic {
    
    fileprivate var form: QuoteForm!
    
    override func setup() {
        super.setup()
        self.form = QuoteForm()
    }
    
    override func start() {
        super.start()
        DispatchQueue.main.async {
            self.chat.sendInput(message: TextMessage(content: "Hello", from: .Other))
            usleep(self.WAIT_TIME_LONG)
            self.chat.sendInput(message: TextMessage(content: "How are you?", from: .Other))
        }
    }
    
}

/*
 pet name: input (text)
 type of pet: selector (dog / cat)
 pet gender: selector (male/female)
 pet breed: selector with search connected to back-end - when searching make request to /breeds - look into gateway-api for docs
 age: selector (<1 year, 1-3 years, 3-5 years, 5-8 years, 8+ years)
 address: start typing postcode, connect to /addresses (check gateway-api for docs), it returns addresses based on search, you select one
 */

enum PetType: String {
    case Cat = "Cat"
    case Dog = "Dog"
}

enum PetGender: String {
    case Male = "Male"
    case Female = "Female"
}

enum PetAge: String {
    case LessOneYear = "<1 year"
    case OneToThreeYears = "1-3 years"
    case ThreeToFiveYears = "3-5 years"
    case FiveToEightYears = "5-8 years"
    case PlusEightYears = "8+ years"
}

class QuoteForm {
    var petName: String!
    var type: PetType!
    var gender: PetGender!
    var breed: String!
    var age: PetAge!
    var address: String!
    
    func printForm() {
        let description = "\(petName), \(type), \(gender), \(breed), \(age), \(address)"
        print(description)
    }
}


