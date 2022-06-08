//
//  AnimalModel.swift
//  Cat or Dog?
//
//  Created by Jessica Perez on 6/8/22.
//

import Foundation


class AnimaModel: ObservableObject {
   @Published var animal = Animal()
    
    ///method for network request of  imagerequest
    func getAnimal() {
        
        let stringUrl = Bool.random() ? catUrl: dogUrl
        
        //create a url object
        let url = URL(string: stringUrl)
        
        //check the url is on nil
        guard url != nil else {
            print("Couldn't create URL Object")
            return
        }
        //get a URL session
        let session = URLSession.shared
        
        
        //create a data task
        let dataTask = session.dataTask(with: url!) { (data, response, error)  in
            //if there is no error , data will be returned
            if error == nil && data != nil {
                //attempt to parse json
                do {
                    ///parse this json and try and make it as an array of dictionaries of string:any
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: Any]] {
                        ///check array is empty
                        let item = json.isEmpty ? [:] : json[0]
                        
                        if let animal = Animal(json: item) {
                            //update user interface
                            DispatchQueue.main.async {
                                while animal.results.isEmpty {} ///waiting until image data is dowloaded then we can get data of animal
                                self.animal = animal
                                
                            }
                        }
                    }
                } catch {
                    print("Couldn't parse JSON")
                }
                
            }
        }
        
        //start the data task
        dataTask.resume()
    }
}
