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
    @State var count = 0
    @State var didAppear = false
    
    @State var workers : [Worker] =
        [Worker(image: "Lowry", name: "Ben Lowry", email: "ben@NewWaveComputers.com", price: "10.00", request: "Walk my dog"),
         Worker(image: "Ginzburg", name: "Aslan Ginzburg", email: "aslan@NewWaveComputers.com", price: "20.00", request: "Mow the lawn"),
           Worker(image: "Yovel", name: "Caroline Galio", email: "caroline@NewWaveComputers.com", price: "10.00", request: "Buy the groceries"),
           Worker(image: "Long", name: "Danny Farah", email: "danny@NewWaveComputers.com", price: "5.00", request: "Carpool my son"),
           Worker(image: "Beer", name: "Madison Beer", email: "madison@NewWaveComputers.com", price: "30.00", request: "Tutor my daughter"),
           Worker(image: "Myers", name: "Michael Myers", email: "michael@NewWaveComputers.com", price: "2.50", request: "Water my plants"),
           Worker(image: "Spencer", name: "Logan Spencer", email: "logan@NewWaveComputers.com", price: "15.00", request: "Wash the car"),
           Worker(image: "Patterson", name: "Bridget Patterson", email: "bridget@NewWaveComputers.com", price: "2.50", request: "Take out the trash")
              ]
    
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
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("requests").observe(DataEventType.value) { (snapshot) in
            guard let workers = snapshot.value as? [String: Any] else {return}
            for(uid, requests) in workers{
                guard let actualRequests = requests as? [Any] else {return}
                for reqData in actualRequests{
                    guard let dataWithinEachIndex = reqData as? [String: Any] else {return}
                    guard let accepted = dataWithinEachIndex["accepted"] as? Bool else {return}
                    guard let description = dataWithinEachIndex["description"] as? String else {return}
                    guard let email = dataWithinEachIndex["workerEmail"] as? String else {return}
                    guard let job = dataWithinEachIndex["job"] as? String else {return}
                    guard let name = dataWithinEachIndex["workerName"] as? String else {return}
                    guard let price = dataWithinEachIndex["price"] as? String else {return}
                    
                    if uid == currentUser && accepted==false{
                        self.workers.append(Worker(image: "user", name: "Pending Worker", email: "Pending Email", price: price, request: job))
                        self.count+=1
                    }
                    else if uid == currentUser && accepted==true{
                        self.workers.append(Worker(image: "user", name: name, email: email, price: price, request: job, description : description))
                        self.count+=1
                    }
                }
            }
    
        }
    }
    
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
    
    var body: some View {
        ZStack{
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

                                    }.onAppear {
                                        if !self.didAppear{
                                            self.loadImage()
                                            self.loadName()
                                            print("My guyyy be appearing once!")
                                            self.updateWorkers()
                                            self.didAppear = true
                                        }
                                    }.onDisappear {
//                                        self.workers =
//                                        [Worker(image: "Lowry", name: "Ben Lowry", email: "ben@NewWaveComputers.com", price: "10.00", request: "Walk my dog"),
//                                         Worker(image: "Ginzburg", name: "Aslan Ginzburg", email: "aslan@NewWaveComputers.com", price: "20.00", request: "Mow the lawn"),
//                                           Worker(image: "Yovel", name: "Caroline Galio", email: "caroline@NewWaveComputers.com", price: "10.00", request: "Buy the groceries"),
//                                           Worker(image: "Long", name: "Danny Farah", email: "danny@NewWaveComputers.com", price: "5.00", request: "Carpool my son"),
//                                           Worker(image: "Beer", name: "Madison Beer", email: "madison@NewWaveComputers.com", price: "30.00", request: "Tutor my daughter"),
//                                           Worker(image: "Myers", name: "Michael Myers", email: "michael@NewWaveComputers.com", price: "2.50", request: "Water my plants"),
//                                           Worker(image: "Spencer", name: "Logan Spencer", email: "logan@NewWaveComputers.com", price: "15.00", request: "Wash the car"),
//                                           Worker(image: "Patterson", name: "Bridget Patterson", email: "bridget@NewWaveComputers.com", price: "2.50", request: "Take out the trash")
//                                              ]
//                                        self.count = 0
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








