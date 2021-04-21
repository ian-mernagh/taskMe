//
//  RequesterList.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/21/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//


import SwiftUI

struct RequestersList: View {
    
    @Binding var requesters : [Requester]
    
    var body: some View {
        List(requesters){ requester in
            HStack{
                
                Image(requester.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipped()
                
                VStack(alignment: .leading){
                    Text(requester.name).font(.system(size: 30))
                        .foregroundColor(.orange)
                    Text(requester.email)
                    
                }
            }.background(Color.white.opacity(0.7))
                .cornerRadius(20)
                .padding(.horizontal, 10)
        }
    }
}

struct RequestersList_Previews: PreviewProvider {
    static var previews: some View {
        RequestersList(requesters: Binding.constant([Requester(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com"),
                                                 Requester(image: "aslan", name: "Aslan", email: "aslan@NewWaveComputers.com"),
                                                 Requester(image: "humphrey", name: "Humphrey", email: "humphrey@NewWaveComputers.com"),
                                                 Requester(image: "joseph", name: "Joseph", email: "joseph@NewWaveComputers.com"),
                                                 Requester(image: "kelly", name: "Kelly", email: "kelly@NewWaveComputers.com"),
                                                 Requester(image: "michael", name: "Michael", email: "michael@NewWaveComputers.com"),
                                                 Requester(image: "prince", name: "Prince", email: "prince@NewWaveComputers.com"),
                                                 Requester(image: "tyler", name: "Tyler", email: "tyler@NewWaveComputers.com")
            ].sorted {$0.name < $1.name}))
    }
}


