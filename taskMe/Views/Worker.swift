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

    init(image : String = "user", name : String = "name", email : String = "email",  type : String = "Friend"){
        self.image = image
        self.name = name
        self.email = email
        self.type = type
    }
}
