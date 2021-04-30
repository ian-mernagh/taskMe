//
//  Requester.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/21/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//


import Foundation

class Requester: Identifiable{
    
    var id = UUID()
    var image : String
    var name : String
    var email : String
    var type: String // Friend, corequester, sibling,
    var requests : [String]

    init(image : String = "user", name : String = "name", email : String = "email",  type : String = "Friend", requests : [String] = ["Wash my car", "Mow my lawn", "Tutor my kid"]){
        self.image = image
        self.name = name
        self.email = email
        self.type = type
    }
}

