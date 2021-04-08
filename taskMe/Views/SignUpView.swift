//
//  SignUpView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/17/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Group {
                    VStack(alignment: .leading) {
                        TextField("Full Name", text: self.$user.fullname).autocapitalization(.words)
                        if !user.validNameText.isEmpty {
                            Text(user.validNameText).font(.caption).foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        TextField("Email Address", text: self.$user.email).autocapitalization(.none).keyboardType(.emailAddress)
                        if !user.validEmailAddressText.isEmpty {
                            Text(user.validEmailAddressText).font(.caption).foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        SecureField("Password", text: self.$user.password)
                        if !user.validPasswordText.isEmpty {
                            Text(user.validPasswordText).font(.caption).foregroundColor(.red)
                        }
                    }
                    VStack(alignment: .leading) {
                        SecureField("Confirm Password", text: self.$user.confirmPassword)
                        if !user.passwordsMatch(_confirmPW: user.confirmPassword) {
                            Text(user.validConfirmPasswordText).font(.caption).foregroundColor(.red)
                        }
                    }
                    VStack() {
                        Button(action: {
                            if (self.user.isTeen==false) {
                                self.user.isTeen = true
                            }
                            else {
                                self.user.isTeen = false
                            }
                        }){
                            if(self.user.isTeen==false) {
                                Text("Requester")
                                .frame(width: 200)
                                .padding(.vertical, 15)
                                .background(Color.green)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                            }
                            else {
                                Text("Worker")
                                .frame(width: 200)
                                .padding(.vertical, 15)
                                .background(Color.green)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                            }
                        }
                    }
                }.frame(width: 300)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                VStack(spacing: 20 ) {
                    Button(action: {
                        Auth.auth().createUser(withEmail: self.user.email, password: self.user.password) { (user, error) in
                            self.userInfo.configureFirebaseStateDidChange()
                            self.presentationMode.wrappedValue.dismiss()
                            self.user.saveTeen(Teen: self.user.isTeen)
                        }
                        
                    }) {
                        Text("Register")
                            .frame(width: 200)
                            .padding(.vertical, 15)
                            .background(Color.green)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .opacity(user.isSignInComplete ? 1 : 0.75)
                    }
                    .disabled(!user.isSignInComplete)
                    Spacer()
                }.padding()
            }.padding(.top)
                .navigationBarTitle("Sign Up", displayMode: .inline)
                .navigationBarItems(trailing: Button("Dismiss") {
                    self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

