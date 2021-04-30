//
//  WorkersList.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/14/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI

struct WorkersList: View {
    
    @Binding var workers : [Worker]
    
    var body: some View {
        List(workers){ worker in
            HStack{
                Image(worker.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipped()
                VStack(alignment: .leading){
                    Text(worker.name).font(.system(size: 30))
                        .foregroundColor(.white)
                    Text(worker.email)
                    Text("Cost " + String(worker.amount))
                }
            }.background(Color("Color4").opacity(0.7))
                .cornerRadius(20)
                .padding(.horizontal, 10)
        }
    }
}

struct WorkersList_Previews: PreviewProvider {
    static var previews: some View {
        WorkersList(workers: Binding.constant([Worker(image: "user", name: "Ben", email: "BenSmith@NewWaveComputers.com"),
                                               Worker(image: "user", name: "Aslan", email: "aslan@NewWaveComputers.com"),
                                               Worker(image: "user", name: "Humphrey", email: "humphrey@NewWaveComputers.com"),
                                               Worker(image: "user", name: "Joseph", email: "joseph@NewWaveComputers.com"),
                                               Worker(image: "user", name: "Kelly", email: "kelly@NewWaveComputers.com"),
                                               Worker(image: "user", name: "Michael", email: "michael@NewWaveComputers.com"),
                                               Worker(image: "user", name: "Prince", email: "prince@NewWaveComputers.com"),
                                               Worker(image: "user", name: "Tyler", email: "tyler@NewWaveComputers.com")
            ].sorted {$0.name < $1.name}))
    }
}

