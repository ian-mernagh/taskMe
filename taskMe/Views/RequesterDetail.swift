//
//  RequesterDetail.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/21/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//


import SwiftUI

struct RequesterDetail: View {
    
    @Binding var requester : Requester
    @Binding var requesters : [Requester]
    @Environment(\.presentationMode) var presentation
    var isAddContact : Bool = true
    
    var types : [String] = ["Friends", "Co-requester", "Business", "Family"]
    
    var body: some View {
        VStack{
            Image(requester.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 300, height: 300, alignment: .center)
            
            
                     
            
            }
        }
    }


struct RequesterDetail_Previews: PreviewProvider {
    static var previews: some View {
       RequesterDetail(requester: Binding.constant(Requester(image: "ben", name: "Ben", email: "ben@ben.ben")), requesters: Binding.constant([Requester(image: "ben", name: "Ben", email: "ben@ben.ben")]))
    }
}

