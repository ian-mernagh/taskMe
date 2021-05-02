//
//  RequesterDefaultView.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/30/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI

struct WorkerDefaultView: View {
    var body: some View{
        TabView{
            MyTasksView()
                .tabItem{
                Image(systemName: "house")
            }
            WorkerHomeView()
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



struct WorkerDefaultView_Previews: PreviewProvider {
    static var previews: some View {
        WorkerDefaultView()
    }
}
