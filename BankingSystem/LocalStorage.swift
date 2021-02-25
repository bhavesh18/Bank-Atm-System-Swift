//
//  LocalStorage.swift
//  BankingSystem
//
//  Created by Bhavesh Sharma on 20/02/21.
//

import Foundation

// converting object to string
func getJsonString(of obj: LocalData) -> String{
    do{
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(obj)
        if let json = String(data: jsonData, encoding: String.Encoding.utf8){
            return json
        }
    }catch{ }
    return ""
}


// storing object locally in a file(.json) as a string.
func saveJsonFile(of data: LocalData){
    let dataStr = getJsonString(of: data)
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask).first {
        let pathWithFilename = documentDirectory.appendingPathComponent("bankrecords.json") //defining file name
//        print(pathWithFilename) // this is thet path where our file will be stored
        do {
            try dataStr.write(to: pathWithFilename, atomically: true, encoding: .utf8)
        } catch {
            // Handle error
            print("file can't be saved")
        }
    }
    
}

// reads the .json file from our local path and return LocalData
func readLocalFile() -> LocalData {
    if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let url = documentDirectory.appendingPathComponent("bankrecords.json")
        let data = NSData(contentsOf: url)
        
        do {
            // converting data to object(i.e Product in our case)
            if let payload = data as Data?{
                let product = try JSONDecoder().decode(LocalData.self, from: payload)
                return product
            }
        } catch {  }
        
    }
    return LocalData()
}

