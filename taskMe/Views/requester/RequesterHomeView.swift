//
//  TheHomeView.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 3/25/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct RequesterHomeView: View {
    
    @State private var showProfileView = false
    @EnvironmentObject var userInfo : UserInfo
    @State private var image: Image = Image("user")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State var user: UserViewModel = UserViewModel()
    
    func loadImage(){
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        
        let database = Database.database().reference().child("users/\(uid)")
        
        database.observeSingleEvent(of: .value) { snapshot in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if let photoURL = postDict["photoURL"]{
                self.image = Image(uiImage: LoadImage.loadImage(photoURL as? String))
            }
        }
    }
    
    @State var workers : [Worker] =
        [Worker(image: "user", name: "Ben Lowry", email: "BenSmith@NewWaveComputers.com"),
         Worker(image: "user", name: "Aslan Ginzburg", email: "aslan@NewWaveComputers.com"),
         Worker(image: "user", name: "Humphrey Chan", email: "humphrey@NewWaveComputers.com"),
         Worker(image: "user", name: "Emily Long", email: "joseph@NewWaveComputers.com"),
         Worker(image: "user", name: "Abigail Page", email: "kelly@NewWaveComputers.com"),
         Worker(image: "user", name: "Michael Myers", email: "michael@NewWaveComputers.com"),
         Worker(image: "user", name: "Prince Phillips", email: "prince@NewWaveComputers.com"),
         Worker(image: "user", name: "Tyler Patterson", email: "tyler@NewWaveComputers.com")
            ].sorted {$0.name < $1.name}
    var body: some View {
        
        
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            HStack{
                
                Spacer()
                ZStack{
                    
                    
                    NavigationView{
                        List{
                            ForEach(workers.indices, id: \.self){
                                i in
                                WorkerCard(worker: self.$workers[i], workers: self.$workers)
                            }
                        }.navigationBarTitle(Text("Workers Nearby"))
                            
                            .navigationBarItems(trailing:
                                HStack {
                                    Button(action: {
                                    }){
                                        image
                                            .renderingMode(.original).resizable().frame(width: 45, height: 45, alignment: .center).cornerRadius(45).padding()
                                    }.sheet(isPresented: $showProfileView){
                                        ProfileView()
                                    }.onAppear {
                                        self.loadImage()
                                    }
                                }
                                
                                
                                
                                
                        )}
                }
            }
        }
    }
}

struct RequesterHomeView_Previews: PreviewProvider {
    static var previews: some View {
        RequesterHomeView()
    }
}








