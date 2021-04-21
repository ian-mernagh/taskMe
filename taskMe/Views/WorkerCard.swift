//
//  WorkerCard.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/14/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct WorkerCard: View {
    
    @Binding var worker : Worker
    @Binding var workers : [Worker]
    
    var body: some View {
        
        HStack{
            Image(worker.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
            NavigationLink(destination: WorkerDetail(worker: $worker, workers: $workers)){
                VStack(alignment: .leading){
                    Text(worker.name)
                        .font(.system(size: 30))
                        .foregroundColor(.orange)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.0001)
                        .lineLimit(1)
                    Text(worker.email)
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

struct WorkerCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkerCard(worker: Binding.constant(Worker(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com")), workers: Binding.constant([Worker(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com")]))
    }
}
