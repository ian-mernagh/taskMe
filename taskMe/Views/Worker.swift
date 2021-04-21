//
//  Worker.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/14/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import Foundation

class Worker: Identifiable{
    
    
    var id = UUID()
    var image : String
    var name : String
    var email : String
    var type: String // Friend, coworker, sibling,
    var requester : String
    var date : Date
    var amount : Double
    var request : String

    init(image : String = "user", name : String = "name", email : String = "email",  type : String = "Friend", requester : String = "Fred", date : Date = Date(), amount : Double = 10, request : String = "Wash my car"){
        self.image = image
        self.name = name
        self.email = email
        self.type = type
        self.requester = requester
        self.date = date
        self.amount = amount
        self.request = request
    }
}