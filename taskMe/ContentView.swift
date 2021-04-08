//
//  ContentView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/16/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    var body: some View {
        Group{
            if userInfo.isUserAuthenticated == .undefined{
                Text("Loading...")
            }
            else if userInfo.isUserAuthenticated == .signedOut{
                LoginView()
            }
            else{
               TheHomeView()
            }
        }.onAppear{
            self.userInfo.configureFirebaseStateDidChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
