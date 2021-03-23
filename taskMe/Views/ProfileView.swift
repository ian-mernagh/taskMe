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
    @EnvironmentObject var userInfo : UserInfo
    @State private var image: Image = Image("user")
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    
    //This function is called when the view appears
    // it will get the url where we saved the user's image
    // and then downoad the image from storage
    func loadImage(){
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        
        let database = Database.database().reference().child("user/\(uid)")
        
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
                    let database = Database.database().reference().child("user/\(uid)")
                    // declare and initize a dictionary
                    //with key photURL and a value that is
                    // our URL
                    let userObject : [String : Any] = ["photoURL" : imageURL.absoluteString]
                    //put URL in database
                    database.setValue(userObject)
                }
            }
        }
        
    }
    var body: some View {
        
        VStack{
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
            
            Button(action: {
                self.showingImagePicker = true
            }){
                
                Text("Change Image")
                    .frame(width: 200)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                
            }.padding()
            
            
            
            
            
            
            Button(action: {
                try! Auth.auth().signOut()
                self.userInfo.isUserAuthenticated = .signedOut
                
            }){
                Text("Sign Out")
                    .frame(width: 200)
                    .padding(.vertical, 15)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                
            }
            
            
        }.sheet(isPresented: $showingImagePicker, onDismiss: saveImage ){
            
            ImagePicker(image: self.$inputImage)
        }   .onAppear {
            self.loadImage()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
