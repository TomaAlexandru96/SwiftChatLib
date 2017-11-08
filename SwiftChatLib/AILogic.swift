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
            self.setup()
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
    func deleteLastAnswer() -> Int {return 2}
}

class QuoteAI: AILogic {
    
    fileprivate var forms: [QuoteForm] = []
    
    override func setup() {
        super.setup()
    }
    
    // returns the number of cells to be deleted
    override func deleteLastAnswer() -> Int {
        return 2
    }
    
    override func start() {
        super.start()
        chat.sendInput(message: TextMessage(content: "Hi there! Let’s get you a price as quickly as we can... You only need to answer 7 quick questions about your pet.", from: .Other))
        delay(time: LONG)
        chat.sendInput(message: TextMessage(content: "How many pets are you looking to insure?", from: .Other))
        let pickerPets = chat.changeInputView(to: InputType.SelectInput)
        pickerPets.loadData(data: [("1", "1"), ("2", "2")])
        
        let pets = Int((waitForInput() as! TextMessage).content)!
        for _ in 0..<pets {
            let form = QuoteForm()
            delay(time: SHORT)
            _ = chat.changeInputView(to: .TextInput)
            chat.sendInput(message: TextMessage(content: "Great, what is your pet’s name?", from: .Other))
            form.petName = (waitForInput() as! TextMessage).content
            
            delay(time: SHORT)
            chat.sendInput(message: TextMessage(content: "Awesome name! is \(form.petName) a dog or a cat?", from: .Other))
            let pickerType = chat.changeInputView(to: .SelectInput)
            pickerType.loadData(data: [("Cat", "Cat"), ("Dog", "Dog")])
            form.type = PetType(rawValue: (waitForInput() as! TextMessage).content)!
            
            delay(time: SHORT)
            chat.sendInput(message: TextMessage(content: "And is \(form.petName) a girl or a boy?", from: .Other))
            let pickerGender = chat.changeInputView(to: .SelectInput)
            pickerGender.loadData(data: [("Female", "Female"), ("Male", "Male")])
            form.gender = PetGender(rawValue: (waitForInput() as! TextMessage).content)!
            
            delay(time: SHORT)
            chat.sendInput(message: TextMessage(content: "How old is \(form.petName)?", from: .Other))
            let pickerAge = chat.changeInputView(to: .SelectInput)
            pickerAge.loadData(data: [
                ("<1 year", "<1 year"),
                ("1-3 years", "1-3 years"),
                ("3-5 years", "3-5 years"),
                ("5-8 years", "5-8 years"),
                ("8+ years", "8+ years")])
            form.age = PetAge(rawValue: (waitForInput() as! TextMessage).content)!
            
            delay(time: SHORT)
            chat.sendInput(message: TextMessage(content: "What type of breed?", from: .Other))
            let pickerBreed = chat.changeInputView(to: .SearchSelectInput)
            pickerBreed.loadData(data: [])
            form.breed = (waitForInput() as! TextMessage).content
            
            delay(time: SHORT)
            chat.sendInput(message: TextMessage(content: "Lastly, where do you and \(form.petName) live?", from: .Other))
            let pickerAddress = chat.changeInputView(to: .SearchSelectInput)
            pickerAddress.loadData(data: [])
            form.address = (waitForInput() as! TextMessage).content
            
            delay(time: SHORT)
            chat.sendInput(message: TextMessage(content: "Great, I’ve got everything I need. You ready to see your price now.", from: .Other))
            chat.sendInput(message: TextMessage(content: form.getDescription(), from: .Other))
            
            self.chat.sendInput(message: TextMessage(content: "Pet: " + form.getDescription(), from: .Other))
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
    var petName: String = ""
    var type: PetType = .Cat
    var gender: PetGender = .Male
    var breed: String = ""
    var age: PetAge = .LessOneYear
    var address: String = ""
    
    func getDescription() -> String{
        return "\(petName), \(type), \(gender), \(breed), \(age), \(address)"
    }
}


