//
//  Workers.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/6/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import Foundation
import SwiftUI

struct workers: Identifiable {
    
    
    let id = UUID()
    let name  : String
    let review : String
    let imageURL : String
    

}

extension workers {
    
    static func all() -> [workers] {
        
        return [
        
            workers(name: "Gal", review: , imageURL: <#T##String#>
        
        
        ]
    }
}
