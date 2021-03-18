//
//  LoginView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/18/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View{
    
    enum Action{
        case signUp, resetPW
    }
    
    @State var showSheet = false
    @State var action : Action?
    @EnvironmentObject var userInfo: UserInfo
    var body: some View{
        SignInWithEmailView(showSheet: $showSheet, action: $action).sheet(isPresented: $showSheet) {
            if self.action == .signUp{
                SignUpView().environmentObject(self.userInfo)
            }
            else{
                ForgotPasswordView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View{
        LoginView()
    }
}
