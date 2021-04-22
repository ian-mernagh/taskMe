//
//  ProfileView.swift
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
    @State public var image: Image = Image("user")
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
                    
                    let database = Database.database().reference().child("users/\(uid)/photoURL")
                    
                    database.setValue(imageURL.absoluteString)
                    
                    var ref: DatabaseReference!

                    ref = Database.database().reference()
                    ref.child("users/\(uid)/name").getData { (error, snapshot) in
                    if let error = error {
                        print("Error getting data \(error)")
                    }
                    else if snapshot.exists() {
                        print("\(snapshot.value!)")
                    }
                    else {
                        print("No data available")
                    }
                    }
                    
                    ref.child("users/\(uid)/photoURL").getData { (error, snapshot) in
                         if let error = error {
                             print("Error getting data \(error)")
                         }
                         else if snapshot.exists() {
                             print("\(snapshot.value!)")
                         }
                         else {
                             print("No data available")
                         }
                     }
                    /*
                     ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
                       if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                         var stars: Dictionary<String, Bool>
                         stars = post["stars"] as? [String : Bool] ?? [:]
                         var starCount = post["starCount"] as? Int ?? 0
                         if let _ = stars[uid] {
                           // Unstar the post and remove self from stars
                           starCount -= 1
                           stars.removeValue(forKey: uid)
                         } else {
                           // Star the post and add self to stars
                           starCount += 1
                           stars[uid] = true
                         }
                         post["starCount"] = starCount as AnyObject?
                         post["stars"] = stars as AnyObject?

                         // Set value and report transaction success
                         currentData.value = post

                         return TransactionResult.success(withValue: currentData)
                       }
                       return TransactionResult.success(withValue: currentData)
                     }) { (error, committed, snapshot) in
                       if let error = error {
                         print(error.localizedDescription)
                       }
                     }
                     */
                    
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
                print(self.user.fullname)
               // print(self.user.isTeen)
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
                //print(self.user.isTeen)
                
            }){
                Text("Sign Out")
                    .frame(width: 200)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
