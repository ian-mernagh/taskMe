//
//  TheHomeView.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 3/25/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct TheHomeView: View {
    
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
        [Worker(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com"),
         Worker(image: "aslan", name: "Aslan", email: "aslan@NewWaveComputers.com"),
         Worker(image: "humphrey", name: "Humphrey", email: "humphrey@NewWaveComputers.com"),
         Worker(image: "joseph", name: "Joseph", email: "joseph@NewWaveComputers.com"),
         Worker(image: "kelly", name: "Kelly", email: "kelly@NewWaveComputers.com"),
         Worker(image: "michael", name: "Michael", email: "michael@NewWaveComputers.com"),
         Worker(image: "prince", name: "Prince", email: "prince@NewWaveComputers.com"),
         Worker(image: "tyler", name: "Tyler", email: "tyler@NewWaveComputers.com")
            ].sorted {$0.name < $1.name}
    var body: some View {

        
            ZStack{

                
                NavigationView{
                    List{
                        ForEach(workers.indices, id: \.self){
                            i in
                            WorkerCard(worker: self.$workers[i], workers: self.$workers)
                        }
                    }.navigationBarTitle("Workers Nearby")
                        .navigationBarItems(trailing: Button(action: {
                            self.showProfileView.toggle()
                        }){
                            image
                                .renderingMode(.original).resizable().frame(width: 45, height: 45, alignment: .center).cornerRadius(45)
                        }.sheet(isPresented: $showProfileView){
                            ProfileView()
                        }.onAppear {
                            self.loadImage()
                            }
                    )
                    
                }
            }
        }
    }


struct TheHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TheHomeView()
    }
}
