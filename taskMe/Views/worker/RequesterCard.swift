//
//  RequesterCard.swift
//  taskMe
//
//  Created by Gal Yovel (student LM) on 4/21/21.
//  Copyright © 2021 Ian Mernagh (student LM). All rights reserved.
//


import SwiftUI
struct RequesterCard: View {
     @Binding var worker : Worker
      @Binding var workers : [Worker]
      
      var body: some View {
          
          HStack{
              Image(worker.image)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 100, height: 100, alignment: .center)
                  .clipped()
              NavigationLink(destination: RequesterDetail(worker: $worker, workers: $workers)){
                  VStack(alignment: .leading){
                      Text(worker.name)
                          .font(.system(size: 30))
                          .foregroundColor(.white)
                          .font(.system(size: 200))
                          .minimumScaleFactor(0.0001)
                          .lineLimit(1)
                      Text(worker.request)
                          .font(.system(size: 20))
                          .foregroundColor(.white)
                          .minimumScaleFactor(0.01)
                          .lineLimit(1)
                      Text("Cost $" + worker.price).font(.system(size: 20))
                      .foregroundColor(.white)
                      .minimumScaleFactor(0.01)
                      .lineLimit(1)
                  }
              }
          }.background(Color.green.opacity(0.7))
              .cornerRadius(10)
              .padding(.horizontal, 10)
      }
}

struct RequesterCard_Previews: PreviewProvider {
    static var previews: some View {
        RequesterCard(worker: Binding.constant(Worker(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com")), workers: Binding.constant([Worker(image: "ben", name: "Ben", email: "BenSmith@NewWaveComputers.com")]))
    }
}
