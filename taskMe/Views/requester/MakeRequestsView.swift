//
//  SignUpView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/17/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct MakeRequestsView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @State private var image: Image = Image("user")
    @State private var inputImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    @State var job : String = ""
    @State var description : String = ""
    @State var price : String = ""
    
    func loadName(){
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(uid)/name").getData { (error, snapshot) in
            
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                self.user.fullname = ("\(snapshot.value!)")
            }
        }
    }
    
    func loadEmail(){
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(uid)/email").getData { (error, snapshot) in
            
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                self.user.email = ("\(snapshot.value!)")
            }
        }
    }
    
    
    func requests(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let database = Database.database().reference().child("requests/\(uid)")
        let userObject : [String : Any] = ["requesterName" : self.user.fullname, "requesterEmail" : self.user.email,  "job" : job, "description" : description, "price" : price,  "accepted" : false]
        database.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let currentRequests = snapshot.value as? [Any] else {
                database.child("0").setValue(userObject)
                print("there are no current requests")
                return}
            print("we made it here")
            database.child("\(currentRequests.count)").setValue(userObject)
        })
                
        // database.setValue(imageURL.absoluteString)
       
        //database.setValue(userObject)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack{
                Color("Color4").edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Make Request").frame(width: 500).padding().font(.largeTitle).foregroundColor(Color.white)
                    Group {
                        VStack(alignment: .leading) {
                            TextField("Job", text: self.$job).autocapitalization(.none)
                            //                            if !user.validNameText.isEmpty {
                            //                                Text(user.validNameText).font(.caption).foregroundColor(.red)
                            //                            }
                        }
                        
                        VStack(alignment: .leading) {
                            TextField("Description", text: self.$description).autocapitalization(.none).keyboardType(.emailAddress)
                            //                            if !user.validEmailAddressText.isEmpty {
                            //                                Text(user.validNameText).font(.caption).foregroundColor(.red)
                            //                            }
                        }
                        
                        VStack(alignment: .leading) {
                            TextField("Price", text: self.$price).autocapitalization(.none).keyboardType(.emailAddress)
                            //                            if !user.validEmailAddressText.isEmpty {
                            //                                Text(user.validNameText).font(.caption).foregroundColor(.red)
                            //                            }
                        }
                        
                    }.frame(width: 300)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    VStack(spacing: 20 ) {
                        Button(action: {
                            self.loadName()
                            self.loadEmail()
                            self.requests()
                            self.job=""
                            self.description=""
                            self.price=""
                        }) {
                            
                            Text("Submit")
                                .frame(width: 200)
                                .padding(.vertical, 15)
                                .background(Color.white)
                                .cornerRadius(8)
                                .foregroundColor(.black)
                                .opacity(user.isSignInComplete ? 1 : 0.75)
                        }
                        //                           .disabled(!user.isSignInComplete)
                        Spacer()
                    }.padding()
                }.padding(.top)
            }
        } .onAppear {
            self.loadName()
            self.loadEmail()
        }
    }
}

struct MakeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        MakeRequestsView()
    }
    
}

