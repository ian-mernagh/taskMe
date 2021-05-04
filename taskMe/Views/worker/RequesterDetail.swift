//
//  RequesterDetail.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/21/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//


import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct RequesterDetail: View {
    
    @Binding var worker : Worker
    @Binding var workers : [Worker]
    @Environment(\.presentationMode) var presentation
    var isAddContact : Bool = true
    @State private var showProfileView = false
    @EnvironmentObject var userInfo : UserInfo
    @State private var image: Image = Image("user")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State var user: UserViewModel = UserViewModel()
    
    func acceptRequest(){
        Database.database().reference().child("requests").observe(DataEventType.value) { (snapshot) in
            guard let workers = snapshot.value as? [String: Any] else {return}
            for(uid, requests) in workers{
                guard let actualRequests = requests as? [Any] else {return}
                for reqData in actualRequests{
                    guard let dataWithinEachIndex = reqData as? [String: Any] else {return}
                    guard let accepted = dataWithinEachIndex["accepted"] as? Bool else {return}
                    guard let description = dataWithinEachIndex["description"] as? String else {return}
                    guard let email = dataWithinEachIndex["requesterEmail"] as? String else {return}
                    guard let job = dataWithinEachIndex["job"] as? String else {return}
                    guard let name = dataWithinEachIndex["requesterName"] as? String else {return}
                    guard let price = dataWithinEachIndex["price"] as? String else {return}
                    
                    if job == self.worker.request{
                        guard let uid = Auth.auth().currentUser?.uid else {return}
                        let database = Database.database().reference().child("requests/\(uid)")
                        let userObject : [String : Any] = ["requesterName" : name, "requesterEmail" : email, "workerName" : self.user.fullname, "workerEmail" : self.user.email, "job" : job, "description" : description, "price" : price,  "accepted" : true]
                        database.setValue(userObject)
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack{
            Image(worker.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 300, height: 300, alignment: .center)
            Text(worker.name)
            Text(worker.price)
            Text(worker.request)
            Button(action: {
                self.acceptRequest()
            }) {
                Text("Accept Request")
                    .frame(width: 200)
                    .padding(.vertical, 15)
                    .background(Color("Color1"))
                    .cornerRadius(8)
                    .foregroundColor(.white).padding()
            }
        }
        
    }
}


struct RequesterDetail_Previews: PreviewProvider {
    static var previews: some View {
        RequesterDetail(worker: Binding.constant(Worker(image: "ben", name: "Ben", email: "ben@ben.ben")), workers: Binding.constant([Worker(image: "ben", name: "Ben", email: "ben@ben.ben")]))
    }
}

