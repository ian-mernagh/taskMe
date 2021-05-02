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

struct WorkerHomeView: View {
    
    @State private var showProfileView = false
    @EnvironmentObject var userInfo : UserInfo
    @State private var image: Image = Image("user")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State var user: UserViewModel = UserViewModel()
    @State var count = 0
    
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
    
    @State var workers : [Worker] = []
    
    func updateWorkers(){
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("requests").observe(DataEventType.value) { (snapshot) in
            guard let workers = snapshot.value as? [String: Any] else {return}
            for(uid, requests) in workers{
                guard let actualRequests = requests as? [Any] else {return}
                for reqData in actualRequests{
                    guard let dataWithinEachIndex = reqData as? [String: Any] else {return}
                    guard let accepted = dataWithinEachIndex["accepted"] as? Bool else {return}
                    guard let description = dataWithinEachIndex["description"] as? String else {return}
                    guard let email = dataWithinEachIndex["email"] as? String else {return}
                    guard let job = dataWithinEachIndex["job"] as? String else {return}
                    guard let name = dataWithinEachIndex["name"] as? String else {return}
                    guard let price = dataWithinEachIndex["price"] as? String else {return}
                    
                    if self.count == 0{
                        self.workers.append(Worker(image: "user", name: "Pending Worker", email: "Pending Email", price: price, request: job))
                    }
                }
            }
            self.count+=1
        }
    }
    
    var body: some View {
        
        ZStack{
            Text("Hello")
            
            NavigationView{
                List{
                    ForEach(workers.indices, id: \.self){
                        i in
                        WorkerCard(worker: self.$workers[i], workers: self.$workers)
                    }
                }.navigationBarTitle("Requests")
                    .navigationBarItems(trailing: Button(action: {
                    }){
                        image
                            .renderingMode(.original).resizable().frame(width: 45, height: 45, alignment: .center).cornerRadius(45)
                    }.sheet(isPresented: $showProfileView){
                        ProfileView()
                    }.onAppear {
                        self.loadImage()
                        self.updateWorkers()
                    }.onDisappear {
                        self.workers = []
                        self.count = 0
                        }
                )
            }
        }
    }
}


struct WorkerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkerHomeView()
    }
}
