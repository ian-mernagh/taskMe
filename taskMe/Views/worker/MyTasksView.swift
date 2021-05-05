//
//  New Request View.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 4/30/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct MyTasksView: View {
    
    @State private var showProfileView = false
    @EnvironmentObject var userInfo : UserInfo
    @State private var image: Image = Image("user")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State var user: UserViewModel = UserViewModel()
    @State var didAppear = false
    
    @State var workers : [Worker] = []
    // @State var workers : [Worker] = [Worker(image: "user", name: "ian", email: "s014396@students.lmsd.org", type: "Yea", requester: "ye", price: "72.2", request: "eat", description: "eat my food")]
    
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
    
    func updateWorkers(){
        self.workers = []
        Database.database().reference().child("requests").observe(DataEventType.value) { (snapshot) in
            guard let workers = snapshot.value as? [String: Any] else {return}
            for(uid, requests) in workers{
                guard let actualRequests = requests as? [Any] else {return}
                for reqData in actualRequests{
                    guard let dataWithinEachIndex = reqData as? [String: Any] else {return}
                    guard let accepted = dataWithinEachIndex["accepted"] as? Bool else {return}
                    guard let description = dataWithinEachIndex["description"] as? String else {return}
                    guard let requesterEmail = dataWithinEachIndex["requesterEmail"] as? String else {return}
                    guard let requesterName = dataWithinEachIndex["requesterName"] as? String else {return}
                    guard let job = dataWithinEachIndex["job"] as? String else {return}
                    guard let price = dataWithinEachIndex["price"] as? String else {return}
                    
                    if accepted == true {
                        self.workers.append(Worker(image: "user", name: requesterName, email: requesterEmail, price: price, request: job, description: description))
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        ZStack{
            NavigationView{
                List{
                    ForEach(workers.indices, id: \.self){
                        i in
                        RequesterCard(worker: self.$workers[i], workers: self.$workers)
                    }
                }.navigationBarTitle("My Tasks")
                    .navigationBarItems(trailing: Button(action: {
                    }){
                        image
                            .renderingMode(.original).resizable().frame(width: 45, height: 45, alignment: .center).cornerRadius(45)
                    }.onAppear {
                        if !self.didAppear{
                            self.loadImage()
                            self.loadName()
                            self.updateWorkers()
                            self.didAppear = true
                        }
                    }.onDisappear {
                        }
                )
            }
        }
    }
}

struct MyTasksView_Previews: PreviewProvider {
    static var previews: some View {
        MyTasksView()
    }
}
