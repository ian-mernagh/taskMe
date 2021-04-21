//
//  ContentView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/16/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct ContentView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    
    func isTeen() {
            guard let uid  = Auth.auth().currentUser?.uid else {return}
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users/\(uid)/isTeen").getData { (error, snapshot) in
                
                if let error = error {
                    print("Error getting data \(error)")
                }
                else if snapshot.exists() {
                    
                }
            }
    }
    
    var body: some View {
        Group{
            if userInfo.isUserAuthenticated == .undefined{
                Text("Loading...")
            }
            else if userInfo.isUserAuthenticated == .signedOut{
                LoginView()
            }
            else if userInfo.isUserAuthenticated == .signedIn {
               RequesterHomeView()
            }
            else {
                
            }
        }.onAppear{
            self.userInfo.configureFirebaseStateDidChange()
            self.isTeen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
