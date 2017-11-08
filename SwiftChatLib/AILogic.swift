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
    fileprivate let SHORT: Double = 0.2
    fileprivate let LONG: Double = 0.5
    fileprivate var inputSema: DispatchSemaphore = DispatchSemaphore(value: 0)
    private let formQueue: DispatchQueue = DispatchQueue.global()
    private var timeSema: DispatchSemaphore = DispatchSemaphore(value: 0)
    private var inputMessage: GenericMessage!
    
    func setChat(chat: ChatViewController) {
        self.chat = chat
    }
    
    func recordInput(message: GenericMessage) {
        inputMessage = message
        formQueue.async {
            self.inputSema.signal()
        }
    }
    
    // has to be in formQueue
    fileprivate func waitForInput() -> GenericMessage {
        inputSema.wait()
        return inputMessage
    }
    
    func startAI() {
        formQueue.async {
            self.start()
        }
    }
    
    // has to be in formQueue
    fileprivate func delay(time: Double) {
        formQueue.asyncAfter(deadline: DispatchTime.now() + time) {
            self.timeSema.signal()
        }
        timeSema.wait()
    }
    
    // to be overriden by children
    fileprivate func setup() {}
    fileprivate func start() {}
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
        chat.sendInput(message: TextMessage(content: "Hello", from: .Other))
        delay(time: LONG)
        self.chat.sendInput(message: TextMessage(content: "How are you?", from: .Other))
        /*let picker = self.chat.changeInputView(to: InputType.SelectInput)
        picker.loadData(data: [("Male", "Male"), ("Female", "Female")])
        print((self.waitForInput() as! TextMessage).content)
        let picker2 = self.chat.changeInputView(to: InputType.SelectInput)
        var data: [(String, String)] = []
        for i in 0..<1000 {
            data.append((String(i), String(i)))
        }
        picker2.loadData(data: data)
        print((self.waitForInput() as! TextMessage).content)*/
    }
    
}

/*
 pet name: input (text)
 type of pet: selector (dog / cat)
 pet gender: selector (male / female)
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


