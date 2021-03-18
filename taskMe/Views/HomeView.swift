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

struct HomeView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @State private var image: Image = Image("user")
    @State private var age: Int? = nil
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    
    func saveAge(){
        guard let input = age else {return}
        age = input
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storage = Storage.storage().reference().child("user/\(uid)")
        
    }
    //this function is called when the view appears. It will get the url where we saved the user's image and then download the image from storage
    func loadImage(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let database = Database.database().reference().child("users/\(uid)")
        
        database.observeSingleEvent(of: .value) { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            //  if let photoURL = postDict["photoURL"]{
            //    self.image = Image(uiImage: LoadImage.loadImage(photoURL as? String))
            //}
        }
    }
    
    func saveImage(){
        //unwrap inputImage. It's an optional that is assigned a value when the user dismisses the imagePicker.
        // exit the function if inputImage is nil, since there won't be anything to save
        guard let input = inputImage else {return}
        //load the slected image into the Image object on our view
        image = Image(uiImage: input)
        
        //now do stuff to save the image in storage
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //now get a reference to our storage object
        let storage = Storage.storage().reference().child("user/\(uid)")
        
        //compress and convert image to data
        guard let imageData = inputImage?.jpegData(compressionQuality: 0.75) else { return }
        
        //store image!
        storage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in
            if let _ = metaData{
                storage.downloadURL { (url, error) in
                    // getting a reference to the current user's uid
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    
                    //unwrap the url object. return if nil
                    guard let imageURL = url else { return }
                    
                    //get a reference to the database object
                    let database = Database.database().reference().child("users/\(uid)")
                    
                    //declare and initialize a dictionary with key photoURL and a value that is our URL
                    let userObject : [String: Any] = ["photoURL" : imageURL.absoluteString]
                    
                    //put URL in the database
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
            }) {
                Text("Change Image")
                    .frame(width: 200)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }.padding()
        }.sheet(isPresented: $showingImagePicker, onDismiss: saveImage) {
            ImagePicker(image: self.$inputImage)
        }.onAppear {
            self.loadImage()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
