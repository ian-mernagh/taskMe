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
    @State var didAppear = false
    
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
    

    @State var workers : [Worker] = [Worker(image: "user", name: "Mark", email: "markingram@gmail.com", price: "20", request: "Clean my yard", description: "Pick up the trash that is on my yard and put it in the garbage bin", accepted: true)]
    
     func updateWorkers(){
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
                      
                    var count = 0
                    for w in self.workers {
                        if !(w.request==job) && accepted == false{
                            count+=1
                        }
                    }
                    
                    if count==self.workers.count {
                        self.workers.append(Worker(image: "user", name: requesterName, email: requesterEmail, price: price, request: job, description: description, accepted: accepted))
                    }
//                      if accepted == false {
//                        newWorkers.append(Worker(image: "user", name: requesterName, email: requesterEmail, price: price, request: job, description: description, accepted: accepted))
//                      }
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
                }.navigationBarTitle("Requests")
                    .navigationBarItems(trailing: Button(action: {
                    }){
                        image
                            .renderingMode(.original).resizable().frame(width: 45, height: 45, alignment: .center).cornerRadius(45)
                    }.onAppear {
                             if !self.didAppear{
                                                                       self.loadImage()
                                                                       self.loadName()
                                                                       print("My guyyy be appearing once!")
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


struct WorkerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkerHomeView()
    }
}
