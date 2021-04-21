//
//  SignInWithEmailView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/18/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct SignInWithEmailView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Binding var showSheet: Bool
    @Binding var action: LoginView.Action?
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
        VStack {
            Text("Task Me").foregroundColor(Color.white).font(.largeTitle)
            Image("logo")
            TextField("Email Address",
                      text: self.$user.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $user.password)
            HStack {
                Spacer()
                Button(action: {
                    self.action = .resetPW
                    self.showSheet = true
                }) {
                    Text("Forgot Password").foregroundColor(.white)
                }
            }.padding(.bottom)
            VStack(spacing: 10) {
                Button(action: {
                    Auth.auth().signIn(withEmail: self.user.email, password: self.user.password) { (user, error) in
                        self.userInfo.configureFirebaseStateDidChange()
                    }
                }) {
                    Text("Login")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color("Color1"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .opacity(user.isLogInComplete ? 1 : 0.75)
                }.disabled(!user.isLogInComplete)
                Button(action: {
                    self.action = .signUp
                    self.showSheet = true
                }) {
                    Text("Sign Up")
                        .padding(.vertical, 15)
                        .frame(width: 200)
                        .background(Color("Color2"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }
            Spacer()
            Spacer()
            Spacer()
        }
        .padding(.top, 100)
        .frame(width: 300)
        .textFieldStyle(RoundedBorderTextFieldStyle()).foregroundColor(Color.black)
        }
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView(showSheet: .constant(false), action: .constant(.signUp))
    }
}
