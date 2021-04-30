//
//  RequesterDefaultView.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/30/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI

struct RequesterDefaultView: View {
    var body: some View{
        TabView{
            RequesterHomeView()
            .tabItem{
                Image(systemName: "house")
            }
            MakeRequestsView()
                .tabItem{
                    Image(systemName: "plus")
            }
            ProfileView()
                           .tabItem{
                               Image(systemName: "person")
                       }
            
        }
        
    }
    
}



struct RequesterDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        RequesterDefaultView()
    }
}
