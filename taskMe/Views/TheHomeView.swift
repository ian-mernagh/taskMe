//
//  TheHomeView.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 3/25/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI

struct TheHomeView: View {
  
    @State private var showProfileView = false
    
    var body: some View {
        
        VStack{
        Button(action: {
            self.showProfileView.toggle()
        }){
            Image("userSymbol")
        }.sheet(isPresented: $showProfileView){
            ProfileView()
        }
        
        
    }
    }
}





struct TheHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TheHomeView()
    }
}
