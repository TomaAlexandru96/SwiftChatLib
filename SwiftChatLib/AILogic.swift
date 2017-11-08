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
    fileprivate let NONE: Double = 0
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
    
    func restart() {
        chat.restart()
    }
    
    // to be overriden by children
    fileprivate func start() {}
    // returns the number of cells to be deleted
    func deleteLastAnswer() -> Int {return 2}
}

class Question {
    
    fileprivate let AI: AILogic
    fileprivate var messengerInput: MessengerInput?
    var message: GenericMessage?
    var input: InputType = .None
    var selectData: [(String, String)]?
    var hideKeyboardAfterInput: Bool = false
    var beforeQueryFunction: (_ query: String) -> Void = {_ in }
    
    init(AI: AILogic) {
        self.AI = AI
    }
    
    func withMessage(message: GenericMessage) -> Question {
        self.message = message
        return self
    }
    
    func withInput(type: InputType) -> Question {
        self.input = type
        return self
    }
    
    func withSelectData(data: [(String, String)]) -> Question {
        self.selectData = data
        return self
    }
    
    func withHideKeyboardAfterInput() -> Question {
        self.hideKeyboardAfterInput = true
        return self
    }
    
    func withBeforeQueryFunction(closure: @escaping (_ question: Question, _ query: String) -> Void) ->           Question {
        self.beforeQueryFunction = {query in closure(self, query)}
        return self
    }
    
    func display() {
        if let message = message {
            AI.chat.sendInput(message: message)
        }
        
        messengerInput = AI.chat.changeInputView(to: input)
        
        if let selectData = selectData, let messengerInput = messengerInput {
            messengerInput.loadData(data: selectData)
        }
        
        if let messengerInput = messengerInput  {
            messengerInput.setBeforeSearch(beforeSearch: beforeQueryFunction)
        }
    }
    
    func awaitAnswer() -> GenericMessage? {
        guard let messengerInput = messengerInput else {
            return nil
        }
        
        let message = AI.waitForInput()
        
        if hideKeyboardAfterInput {
            messengerInput.hideKeyboard()
        }
        
        return message
    }
 
    func start() -> GenericMessage? {
        display()
        return awaitAnswer()
    }
}

class QuoteAI: AILogic {
    
    fileprivate var forms: [QuoteForm] = []
    
    override func deleteLastAnswer() -> Int {
        return 2
    }
    
    override func start() {
        super.start()
        
        var formsCount = 0
        
        _ = Question(AI: self)
            .withMessage(message: TextMessage(content: "Hi there! Let’s get you a price as quickly as we can... You only need to answer 7 quick questions about your pet.", from: .Other))
            .start()
        formsCount = Int((Question(AI: self)
            .withMessage(message: TextMessage(content: "How many pets are you looking to insure?", from: .Other))
            .withInput(type: .SelectInput)
            .withSelectData(data: [("1", "1"), ("2", "2")])
            .start()! as! TextMessage).content)!
        
        for _ in 0..<formsCount {
            let form = QuoteForm()
            
            form.petName = (Question(AI: self)
                .withMessage(message: TextMessage(content: "Great, what is your pet’s name?", from: .Other))
                .withInput(type: .TextInput)
                .withHideKeyboardAfterInput()
                .start() as! TextMessage).content
            
            form.type = (Question(AI: self)
                .withMessage(message: TextMessage(content: "Awesome name! is \(form.petName) a dog or a cat?", from: .Other))
                .withInput(type: .TwoButtonsInput)
                .withSelectData(data: [("Dog", "Dog"), ("Cat", "Cat")])
                .start() as! TextMessage).content
            
            form.gender = (Question(AI: self)
                .withMessage(message: TextMessage(content: "And is \(form.petName) a girl or a boy?", from: .Other))
                .withInput(type: .TextInput)
                .withInput(type: .TwoButtonsInput)
                .withSelectData(data: [("Boy", "Boy"), ("Girl", "Girl")])
                .start() as! TextMessage).content
            
            form.age = (Question(AI: self)
                .withMessage(message: TextMessage(content: "How old is \(form.petName)?", from: .Other))
                .withInput(type: .SelectInput)
                .withSelectData(data: [
                        ("<1 year", "<1 year"),
                        ("1-3 years", "1-3 years"),
                        ("3-5 years", "3-5 years"),
                        ("5-8 years", "5-8 years"),
                        ("8+ years", "8+ years")
                    ])
                .start() as! TextMessage).content
            
            form.breed = (Question(AI: self)
                .withMessage(message: TextMessage(content: "What type of breed?", from: .Other))
                .withInput(type: .SearchSelectInput)
                .withSelectData(data: [("None for now", "None for now")])
                .start() as! TextMessage).content
            
            form.address = (Question(AI: self)
                .withMessage(message: TextMessage(content: "Lastly, where do you and \(form.petName) live?", from: .Other))
                .withInput(type: .SearchSelectInput)
                .withSelectData(data: [("None for now", "None for now")])
                .withBeforeQueryFunction(closure: {question, query in
                    question.messengerInput?.loadData(data: [
                            ("Every time you search", "Every time you search")
                        ])
                })
                .start() as! TextMessage).content
            
            _ = Question(AI: self)
                .withMessage(message: TextMessage(content: "Great, I’ve got everything I need. You ready to see your price now.", from: .Other))
                .start()
            
            _ = Question(AI: self)
                .withMessage(message: TextMessage(content: "Pet: " + form.getDescription(), from: .Other))
                .start()
            forms.append(form)
        }
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

class QuoteForm {
    var petName: String = ""
    var type: String = ""
    var gender: String = ""
    var breed: String = ""
    var age: String = ""
    var address: String = ""
    
    func getDescription() -> String{
        return "\(petName), \(type), \(gender), \(breed), \(age), \(address)"
    }
}


