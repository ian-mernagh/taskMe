//
//  RequesterCard.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/21/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//


import SwiftUI
struct RequesterCard: View {
    
    @Binding var requester : Requester
    @Binding var requesters : [Requester]
    
    var body: some View {
        
        HStack{
            
            Image(requester.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
            NavigationLink(destination: RequesterDetail(requester: $requester, requesters: $requesters)){
                VStack(alignment: .leading){
                    Text(requester.name)
                        .font(.system(size: 30))
                        .foregroundColor(.orange)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.0001)
                        .lineLimit(1)
                    Text(requester.email)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                }
            }
        }.background(Color.white.opacity(0.7))
            .cornerRadius(20)
            .padding(.horizontal, 10)
    }
    
}

struct RequesterCard_Previews: PreviewProvider {
    static var previews: some View {
        RequesterCard(requester: Binding.constant(Requester(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com")), requesters: Binding.constant([Requester(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com")]))
    }
}
