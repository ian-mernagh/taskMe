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
    @State var isTeen = false
    
    func getIsTeen() {
            guard let uid  = Auth.auth().currentUser?.uid else {return}
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users/\(uid)/isTeen").getData { (error, snapshot) in
                
                if let error = error {
                    print("Error getting data \(error)")
                }
                else if snapshot.exists() {
                    self.isTeen = snapshot.value as! Bool
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
            else if userInfo.isUserAuthenticated == .signedIn && self.isTeen == false{
               RequesterHomeView()
            }
            else if userInfo.isUserAuthenticated == .signedIn && self.isTeen == true{
                WorkerHomeView()
            }
            else{
                
            }
        }.onAppear{
            self.userInfo.configureFirebaseStateDidChange()
            self.getIsTeen()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
