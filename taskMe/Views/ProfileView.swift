//
//  HomeView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 3/18/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct ProfileView: View {
    
    //@EnvironmentalObject var userObject : [String : Any]
    @EnvironmentObject var userInfo : UserInfo
    @State private var image: Image = Image("user")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State var user: UserViewModel = UserViewModel()
    
    
    //This function is called when the view appears
    // it will get the url where we saved the user's image
    // and then downoad the image from storage
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
    
    
    //This function will b ecalled when the user dismisses the imagepicker
    //It will store the image ha they selected
    //in storage, get the urls
    
    func saveImage(){
        guard let input = inputImage else {return}
        //load the selected inage into the Image object on our view
        image = Image(uiImage: input)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storage = Storage.storage().reference().child("user/\(uid)")
        
        //compress and convert image to data
        guard let imageData = inputImage?.jpegData(compressionQuality: 0.75) else {return}
        
        //store our image
        storage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in
            if let _ = metaData{
                storage.downloadURL { (url, error) in
                    
                    guard let uid = Auth.auth().currentUser?.uid else{return}
                    //unwarp the url object. Return if nil
                    guard let imageURL = url else {return}
                    
                    let database = Database.database().reference().child("users/\(uid)")
                    
                   // database.setValue(imageURL.absoluteString)
                    let userObject : [String : Any] = ["photoURL" : imageURL.absoluteString, "isTeen" : self.user.isTeen, "name" : self.user.fullname, "email" : self.user.email]
                    database.setValue(userObject)
                }
            }
        }
        /*
         func saveImage(){
         
         guard let input = inputImage else {return}
         //load the selected inage into the Image object on our view
         image = Image(uiImage: input)
         
         //stuff to save the image
         guard let uid = Auth.auth().currentUser?.uid else {return}
         
         //now get a refrence to our storage object
         let storage = Storage.storage().reference().child("user/\(uid)")
         
         //compress and convert image to data
         guard let imageData = inputImage?.jpegData(compressionQuality: 0.75) else {return}
         
         //store our image
         storage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in
         if let _ = metaData{
         storage.downloadURL { (url, error) in
         
         guard let uid = Auth.auth().currentUser?.uid else{return}
         //unwarp the url object. Return if nil
         guard let imageURL = url else {return}
         
         // get a refrnece to the database object
         let database = Database.database().reference().child("users/\(uid)")
         // declare and initize a dictionary
         //with key photURL and a value that is
         // our URL
         let userObject : [String : Any] = ["photoURL" : imageURL.absoluteString, "isTeen" : self.user.isTeen, "name" : self.user.fullname]
         //put URL in database
         database.setValue(userObject)
         /*
         let database2 = Database.database().reference().child("users/\(uid)/isTeen")
         let userObject2 : [String : Bool] = ["isTeen" : self.user.isTeen]
         database2.setValue(userObject2)
         let database3 = Database.database().reference().child("users/\(uid)/fullName")
         let userObject3 : [String : String] = ["name" : self.user.fullname]
         database3.setValue(userObject3)
         guard let uid = Auth.auth().currentUser?.uid else {return}
         let database2 = Database.database().reference().child("users/\(uid)/")
         print(self.user.isTeen)
         let userObject2 : [String : Bool] = ["isTeen" : self.user.isTeen]
         database2.setValue(userObject2)
         print(self.user.fullname)
         let database3 = Database.database().reference().child("users/\(uid)/")
         let userObject3 : [String : String] = ["name" : self.user.fullname]
         database3.setValue(userObject3)
         self.userInfo.configureFirebaseStateDidChange()
         self.presentationMode.wrappedValue.dismiss()
         */
         }
         }
         }
         */
        /*
         let database2 = Database.database().reference().child("users/\(uid)/isTeen")
         database2.setValue(user.isTeen)
         */
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
    
    func loadIsTeen(){
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(uid)/isTeen").getData { (error, snapshot) in
            
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                self.user.isTeen = snapshot.value as! Bool
            }
        }
    }
    
    func loadEmail(){
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(uid)/email").getData { (error, snapshot) in
            
            if let error = error {
                print("Error getting data \(error)")
            }
            else if snapshot.exists() {
                self.user.email = ("\(snapshot.value!)")
            }
        }
    }
    
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack{
                Text("Profile").frame(width: 200).padding().font(.largeTitle).foregroundColor(Color.white)
                HStack(alignment: .center){
                    Text("Name").frame(width: 200)
                        .padding(.trailing, 4)
                    .foregroundColor(.white)
                    VStack() {
                        TextField(self.user.fullname, text: self.$user.fullname).autocapitalization(.words).foregroundColor(Color.white)
                    }
                }
                HStack(alignment: .center){
                    Text("Email").frame(width: 200)
                        .padding(.trailing,4)
                    .foregroundColor(.white)
                    VStack() {
                        TextField(self.user.email, text: self.$user.email).autocapitalization(.words).foregroundColor(Color.white)
                    }
                }.padding(.bottom, 5)
                //image
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200, alignment: .center)
                    .clipped().padding()
                
                Button(action: {
                    self.showingImagePicker = true
                }){
                    
                    Text("Change Image")
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(Color("Color1"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    
                }.padding()
                VStack() {
                    Button(action: {
                        if (self.user.isTeen==false) {
                            self.user.isTeen = true
                        }
                        else if (self.user.isTeen==true) {
                            self.user.isTeen = false
                        }
                    }){
                        
                        if(self.user.isTeen==false) {
                            Text("Requester")
                                .frame(width: 200)
                                .padding(.vertical, 15)
                                .background(Color("Color1"))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                            
                        else if (self.user.isTeen==true){
                            Text("Worker")
                                .frame(width: 200)
                                .padding(.vertical, 15)
                                .background(Color("Color2"))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        
                    }
                    
                }.padding()

                Button(action: {
                    self.saveImage()
                    try! Auth.auth().signOut()
                    self.userInfo.isUserAuthenticated = .signedOut
                    
                    }){
                    Text("Sign Out")
                        .frame(width: 200)
                        .padding(.vertical, 15)
                        .background(Color("Color2"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                    
                }.padding()
                
            }.sheet(isPresented: $showingImagePicker, onDismiss: saveImage){
                ImagePicker(image: self.$inputImage)
            }   .onAppear {
                self.loadName()
                self.loadEmail()
                self.loadIsTeen()
                self.loadImage()
            }.onDisappear() {
                self.saveImage()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
