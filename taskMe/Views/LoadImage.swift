//
//  LoadImage.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/18/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import Foundation
import SwiftUI

class LoadImage{
    class func loadImage(_ urlString: String?) -> UIImage{
        do{
            guard var unWrappedString = urlString else { return UIImage(named: "default") ?? UIImage() }
            guard let url = URL(string: unWrappedString) else { return UIImage(named: "default") ?? UIImage()}
            
            let data: Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
            
        } catch{
            return UIImage(named: "default") ?? UIImage()
        }
    }
}
