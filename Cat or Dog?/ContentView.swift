//
//  ContentView.swift
//  Cat or Dog?
//
//  Created by Jessica Perez on 6/8/22.
//

import SwiftUI

struct ContentView: View {
    //animal model var
    @ObservedObject var model: AnimaModel
    var body: some View {
        VStack {
            GeometryReader { geometry  in
                Image(uiImage: UIImage(data: model.animal.imageData ?? Data()) ?? UIImage())
                
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
            }
           
            
            HStack {
                Text("What is it? ")
                    .font(.title)
                    .bold()
                    .padding(.leading,10)
                
                Button(action :  {
                    self.model.getAnimal()
                    
                    Spacer()
                    
                } ,label: {
                    Text("Next")
                        .bold()
                })
                .padding(.trailing, 10)
            }
            List(model.animal.results) { result in
                HStack {
                    Text(result.imageLabel)
                    Spacer()
                    Text(
                        String(format: "%.2f%%", result.confidence * 100)
                    )
                }
            }
        }
        .onAppear(perform: model.getAnimal)
        .opacity(model.animal.imageData == nil ? 0 : 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: AnimaModel())
    }
}
