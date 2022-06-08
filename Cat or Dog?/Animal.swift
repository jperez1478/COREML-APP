//
//  Animal.swift
//  Cat or Dog?
//
//  Created by Jessica Perez on 6/8/22.
//

import Foundation
import CoreML
import Vision


struct Result: Identifiable {
    var imageLabel: String
    var confidence: Double
    var id = UUID()
}

//class model

class Animal {
    // url for the image
    var imageUrl: String
    //image data
    var imageData: Data?
    
    //classified results
    var results: [Result]
    
    let modelFile = try! MobileNetV2(configuration: MLModelConfiguration())
    
    //// initializers :  Properties will be empty
    ///  animal class has  no information but if u need an animal will have an empty one
    init() {
        self.imageUrl = ""
        self.imageData = nil
        self.results = []
    }
    ///initializer for the json
    ///json is structure in string in this case
    init?(json: [String: Any]){
        
    //check json url
    guard let imageUrl = json["url"] as? String else {
        return nil
    }
    //set the animal properties
        self.imageUrl = imageUrl
        self.imageData = nil
        self.results = []
    //download the image data
    getImage()
    }
    
    func getImage() {
        //create url object
        let url = URL(string: imageUrl)
        //check the url is nill
        guard url != nil else {
            print("Couldn't get URL oobject")
            return
        }
        
        //get url session
        let session = URLSession.shared
        
        //create the datatask
        let dataTask =  session.dataTask(with: url!) { (data,response,error) in
            
            //check that there are no errors and that there was data
            
            if error == nil && data != nil {
                self.imageData = data
                self.classifyAnimal()
            }
        }
        
        //start the data task
        dataTask.resume()
        
    }
    
    func classifyAnimal() {
        //get refrence to the model
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        //create an image handler
        let handler = VNImageRequestHandler(data: imageData!) //convert image data core ml model can handle
        //create a request to the model
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Couldn't classify animal")
                return
            }
            
            //update results
            for classification in results {
                var identifier = classification.identifier
                identifier = identifier.prefix(1).capitalized + identifier.dropFirst()
                self.results.append(Result(imageLabel: identifier, confidence: Double(classification.confidence)))
            }
               
                
            
        }
        //execute the request
        do {
            try handler.perform([request])
            
        } catch {
            print("Invalid Image")
        }
        
    }
}
