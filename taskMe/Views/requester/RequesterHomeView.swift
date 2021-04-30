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
        [Worker(image: "Lowry", name: "Ben Lowry", email: "ben@NewWaveComputers.com", amount: 10, request: "Walk my dog"),
         Worker(image: "Ginzburg", name: "Aslan Ginzburg", email: "aslan@NewWaveComputers.com", amount: 20, request: "Mow the lawn"),
         Worker(image: "Yovel", name: "Caroline Galio", email: "caroline@NewWaveComputers.com", amount: 10, request: "Buy the groceries"),
         Worker(image: "Long", name: "Danny Farah", email: "danny@NewWaveComputers.com", amount: 5, request: "Carpool my son"),
         Worker(image: "Beer", name: "Madison Beer", email: "madison@NewWaveComputers.com", amount: 30, request: "Tutor my daughter"),
         Worker(image: "Myers", name: "Michael Myers", email: "michael@NewWaveComputers.com", amount: 2.5, request: "Water my plants"),
         Worker(image: "Spencer", name: "Logan Spencer", email: "logan@NewWaveComputers.com", amount: 15, request: "Wash the car"),
         Worker(image: "Patterson", name: "Bridget Patterson", email: "bridget@NewWaveComputers.com", amount: 2.5, request: "Take out the trash")
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
                        }.navigationBarTitle(Text("My Requests"))
                            
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








