//
//  FireMethods.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 24/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class FireMethods {
    
    static func listen<T>(db: Firestore, name: String, documentName: String, dataFieldName: String, decodeObject: T.Type, completionHandler: @escaping (T) -> Void) -> ListenerRegistration where T: Decodable {
        return db.collection(name).document(documentName).addSnapshotListener { (documentSnapshot, error) in
            if let e = error {
                print("error retrieving from Firestore, \(e)")
            } else {
                if let docSnapshot = documentSnapshot {
                    if let data = docSnapshot.data() {
                        if let dataField = data[dataFieldName] {
                            do {
                                let dataFieldDecoded = try FirebaseDecoder().decode(decodeObject, from: dataField)
                                completionHandler(dataFieldDecoded)
                            } catch {
                                print("Error decoding")
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func get<T>(db: Firestore, name: String, documentName: String, dataFieldName: String, decodeObject: T.Type, completionHandler: @escaping (T) -> Void) where T: Decodable {
        db.collection(name).document(documentName).getDocument { (doc, error) in
            if let e = error {
                print("error retrieving from Firestore, \(e)")
            } else {
                if let doc = doc {
                    if let data = doc.data() {
                        if let dataField = data[dataFieldName] {
                            do {
                                let dataFieldDecoded = try FirebaseDecoder().decode(decodeObject, from: dataField)
                                completionHandler(dataFieldDecoded)
                            } catch {
                                print("Error decoding")
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func save<T>(object: T, name: String, documentName: String, dataFieldName: String) where T: Codable {
        let db = Firestore.firestore()
        let firebaseRemoteItem = try! FirebaseEncoder().encode(object)
        
        db.collection(name).document(documentName).setData([
            dataFieldName : firebaseRemoteItem,
        ]) { (error) in
            if let e = error {
                print("Error saving: \(e)")
            } else {
                print("Successfully Saved")
            }
        }
        
    }
    
    static func save(dict: [String: Any], name: String, documentName: String) {
        let db = Firestore.firestore()
        db.collection(name).document(documentName).setData(
            dict
        ) { (error) in
            if let e = error {
                print("Error saving: \(e)")
            } else {
                print("Successfully Saved")
            }
        }
    }
    
    
    
}
