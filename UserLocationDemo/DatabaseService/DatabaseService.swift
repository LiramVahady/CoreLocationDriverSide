//
//  DatabaseService.swift
//  UserLocationDemo
//
//  Created by me on 04/11/2021.
//
//

import Foundation
import FirebaseDatabase

class DatabaseService{
    
    static let shared = DatabaseService()
    
    private let databaseLocation = "trackLocation"
    
    var databaseRef: DatabaseReference!
    
    func setUserCurrentLocation(lat: Double, long: Double){
        
        databaseRef = Database.database().reference()
        let dict: [String:Any] = ["lat":lat, "long":long]
        databaseRef.child(databaseLocation).setValue(dict)
    }
    
    func fetchCurrentCoordinates(completion: @escaping ([String:Any])->Void){
        databaseRef = Database.database().reference()
        
        databaseRef.child(databaseLocation).observeSingleEvent(of: .value) { snapahot in
            
            if let dictCoordinate = snapahot.value as? [String:Any]{
               completion(dictCoordinate)
            }
        }
    }
    
}
