//
//  TemporaryData.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 07/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

private let mess1 = "Hey, how are u?"
private let mess2 = "Fine, what about you? how is you're day? I really like FinTech and hope I will get a job"
private let mess3 = "Cool! Thanks"
private let mess4 = "Just a test"

private let mess5 = "I'm not incredible Hulk"
private let mess6 = "Nice Iron Fist"
private let mess7 = "Another test"
private let mess8 = "Cool application"
private let mess9 = "Do you have tinkoff bank? Tell me something about this service, please"
private let mess10 = "I'm iOS-Dev"
private let mess11 = "iOS better than android"

class TemporaryData: NSObject {
    class func generateData() -> [Person] {
        
        let date1 = Date(timeIntervalSinceNow: -1000)
        let date2 = Date(timeIntervalSinceNow: -100000)
        let date3 = Date(timeIntervalSinceNow: -150)
        let date4 = Date(timeIntervalSinceNow: -900)
        let date5 = Date(timeIntervalSinceNow: -3000)
        let date6 = Date(timeIntervalSinceNow: -4000)
        let date7 = Date(timeIntervalSinceNow: -200000)
        let date8 = Date(timeIntervalSinceNow: -150000)
        let date9 = Date(timeIntervalSinceNow: -500)
        let date10 = Date(timeIntervalSinceNow: -800)
        let date11 = Date(timeIntervalSinceNow: -2000000)
        let date12 = Date(timeIntervalSinceNow: -15000000)
        let date13 = Date(timeIntervalSinceNow: -5000000)
        let date14 = Date(timeIntervalSinceNow: -80000)
        
        
        let venom = Person(name: "Eddie Brock", unread: true, online: false, date: date1)
        let daredevil = Person(name: "Mat Murdock", unread: true, online: true, date: date2)
        let cage = Person(name: "Luke Cage", unread: false, online: true, date: date3)
        let ironFist = Person(name: "Danny Rand", unread: false, online: false, date: date4)
        let spiderMan = Person(name: "Peter Parker", unread: false, online: true, date: date5)
        let zimin = Person(name: "Alexandr Zimin", unread: false, online: false, date: date6)
        let carnage = Person(name: "Cletus Cassidy", unread: true, online: false, date: date7)
        let flash = Person(name: "Barry Allen", unread: true, online: false, date: date8)
        let doom = Person(name: "Victor Fondoom", unread: true, online: true, date: date9)
        let cap = Person(name: "Steve Rogers", unread: false, online: true, date: date10)
        
        let batman = Person(name: "Bruce Wayne", unread: true, online: false, date: date11)
        let superman = Person(name: "Clark Kent", unread: true, online: true, date: date12)
        let wonderwoman = Person(name: "Diana Prince", unread: false, online: true, date: date13)
        let joker = Person(name: "Mr J", unread: false, online: false, date: date14)
        let luke = Person(name: "Luke Skywalker", unread: false, online: true, date: date5)
        let obi = Person(name: "Obivan Kenobi", unread: false, online: false, date: date6)
        let yoda = Person(name: "Master Yoda", unread: true, online: false, date: date7)
        let vader = Person(name: "Darth Vader", unread: true, online: false, date: date8)
        let rd2d = Person(name: "R2D2", unread: true, online: true, date: date9)
        let c3po = Person(name: "C3P0", unread: false, online: true, date: date10)
        
        let messageModel1 = MessageModel(textMessage: mess1, incoming: true)
        let messageModel2 = MessageModel(textMessage: mess2, incoming: false)
        let messageModel3 = MessageModel(textMessage: mess3, incoming: true)
        
        let messageModel4 = MessageModel(textMessage: mess4, incoming: false)
        let messageModel5 = MessageModel(textMessage: mess2, incoming: true)
        let messageModel6 = MessageModel(textMessage: mess3, incoming: false)
        
        let messageModel7 = MessageModel(textMessage: mess6, incoming: true)
        let messageModel8 = MessageModel(textMessage: mess3, incoming: false)
        let messageModel9 = MessageModel(textMessage: mess9, incoming: true)
        
        let messageModel10 = MessageModel(textMessage: mess9, incoming: true)
        let messageModel11 = MessageModel(textMessage: mess8, incoming: false)
        let messageModel12 = MessageModel(textMessage: mess7, incoming: true)
        
        let messageModel13 = MessageModel(textMessage: mess5, incoming: false)
        let messageModel14 = MessageModel(textMessage: mess5, incoming: true)
        let messageModel15 = MessageModel(textMessage: mess10, incoming: true)
        
        let messageModel16 = MessageModel(textMessage: mess11, incoming: true)
        let messageModel17 = MessageModel(textMessage: mess10, incoming: false)
        let messageModel18 = MessageModel(textMessage: mess1, incoming: true)
        
        let messageModel22 = MessageModel(textMessage: mess4, incoming: true)
        let messageModel23 = MessageModel(textMessage: mess2, incoming: false)
        let messageModel24 = MessageModel(textMessage: mess8, incoming: true)
        
        let messageModel25 = MessageModel(textMessage: mess2, incoming: false)
        let messageModel26 = MessageModel(textMessage: mess10, incoming: true)
        let messageModel27 = MessageModel(textMessage: mess11, incoming: false)
        
        
        venom.messageData = [messageModel1, messageModel2, messageModel3]
        daredevil.messageData = [messageModel4, messageModel5, messageModel6]
        cage.messageData = [messageModel7, messageModel8, messageModel9]
        ironFist.messageData = [messageModel10, messageModel11, messageModel12]
        spiderMan.messageData = [messageModel13, messageModel14, messageModel15]
        zimin.messageData = [messageModel16, messageModel17, messageModel18]
        flash.messageData = [messageModel22, messageModel23, messageModel24]
        doom.messageData = [messageModel27, messageModel26, messageModel25]
        carnage.messageData = [messageModel22, messageModel23, messageModel13]
        cap.messageData = [messageModel22, messageModel23, messageModel13]
        
        
        batman.messageData = [messageModel1, messageModel2, messageModel3]
        superman.messageData = [messageModel4, messageModel5, messageModel6]
        wonderwoman.messageData = [messageModel7, messageModel8, messageModel9]
        joker.messageData = [messageModel10, messageModel11, messageModel12]
        luke.messageData = [messageModel13, messageModel14, messageModel15]
        obi.messageData = [messageModel16, messageModel17, messageModel18]
        yoda.messageData = [messageModel22, messageModel23, messageModel24]
        vader.messageData = [messageModel27, messageModel26, messageModel25]
        
        
        
        let heroes = [venom, daredevil, cage, ironFist, spiderMan, zimin, carnage, flash, doom, cap, batman, superman, wonderwoman, joker, luke, obi, yoda, vader, rd2d, c3po]
        
        for user in heroes {
            if user.messageData == nil {
                user.date = nil
            }
        }
        
        return heroes
    }
    
}


