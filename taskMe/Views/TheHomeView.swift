//
//  TheHomeView.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 3/25/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI

struct TheHomeView: View {
    
    @State private var showProfileView = false
    
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
                }.navigationBarTitle("")
                    .navigationBarItems(trailing: Button(action: {
                        self.showProfileView.toggle()
                    }){
                        Image("user")
                            .renderingMode(.original).resizable().frame(width: 45, height: 45, alignment: .center)
                    }.sheet(isPresented: $showProfileView){
                        ProfileView()
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
