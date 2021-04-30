//
//  YourRequestsView.swift
//  taskMe
//
//  Created by Ian Mernagh (student LM) on 4/30/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI

struct MakeRequestsView: View {
    var body: some View {
         ZStack{
                   Color.black.edgesIgnoringSafeArea(.all)
                   HStack{
                       
                       Spacer()
                       ZStack{
                           NavigationView{
                               List{
                                   ForEach(workers.indices, id: \.self){
                                       i in
                                       WorkerCard(worker: self.$workers[i], workers: self.$workers)
                                   }
                               }.navigationBarTitle(Text("Workers Nearby"))
                                   
                                   .navigationBarItems(trailing:
                                       HStack {
                                           Button(action: {
                                               self.showProfileView.toggle()
                                           }){
                                               image
                                                   .renderingMode(.original).resizable().frame(width: 45, height: 45, alignment: .center).cornerRadius(45).padding()
                                           }.sheet(isPresented: $showProfileView){
                                               ProfileView()
                                           }.onAppear {
                                               self.loadImage()
                                           }
                                       }
                                       
                                       
                                       
                                       
                               )}
                       }
                   }
               }
        
    }
}

struct MakeRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        MakeRequestsView()
    }
}
