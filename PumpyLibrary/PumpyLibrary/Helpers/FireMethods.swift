//
//  FireMethods.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 24/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CodableFirebase

public class FireMethods {
    
    static var db: Firestore {
        return FirebaseStore.shared.db
    }
    
    public static func listen<T>(name: Username,
                                 documentName: String,
                                 dataFieldName: String,
                                 decodeObject: T.Type,
                                 completionHandler: @escaping (T) -> Void) -> ListenerRegistration? where T: Decodable {
        
        guard case let .account(accountName) = name else {
            print("Signed in as guest saving \(documentName)")
            return nil
        }
        
        return db.collection(accountName).document(documentName).addSnapshotListener { (documentSnapshot, error) in
            if let e = error {
                print("error retrieving from Firestore \(documentName) \(dataFieldName), \(e)")
            } else {
                if let docSnapshot = documentSnapshot {
                    if let data = docSnapshot.data() {
                        if let dataField = data[dataFieldName] {
                            do {
                                let dataFieldDecoded = try FirebaseDecoder().decode(decodeObject, from: dataField)
                                completionHandler(dataFieldDecoded)
                            } catch {
                                print("Error decoding \(documentName) \(dataFieldName)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    public static func get<T>(name: Username,
                              documentName: String,
                              dataFieldName: String,
                              decodeObject: T.Type,
                              completionHandler: @escaping (T) -> Void) where T: Decodable {
        
        guard case let .account(accountName) = name else {
            print("Signed in as guest saving \(documentName)")
            return
        }
        
        db.collection(accountName).document(documentName).getDocument { (doc, error) in
            if let e = error {
                print("error retrieving from Firestore \(documentName) \(dataFieldName), \(e)")
            } else {
                if let doc = doc {
                    if let data = doc.data() {
                        if let dataField = data[dataFieldName] {
                            do {
                                let dataFieldDecoded = try FirebaseDecoder().decode(decodeObject, from: dataField)
                                completionHandler(dataFieldDecoded)
                            } catch {
                                print("Error decoding \(documentName) \(dataFieldName)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    public static func save<T>(object: T, name: Username, documentName: String, dataFieldName: String) where T: Encodable {
        
        guard case let .account(accountName) = name else {
            print("Signed in as guest saving \(documentName) \(dataFieldName)")
            return
        }
        
        guard let firebaseRemoteItem = try? FirebaseEncoder().encode(object) else { return }

        db.collection(accountName).document(documentName).setData([
            dataFieldName : firebaseRemoteItem,
        ]) { (error) in
            if let e = error {
                print("Error saving \(documentName) \(dataFieldName): \(e)")
            } else {
                print("Successfully Saved \(documentName) \(dataFieldName)")
            }
        }
    }
    
    public static func save(dict: [String: Any], name: Username, documentName: String) {
        
        guard case let .account(accountName) = name else {
            print("Signed in as guest saving \(documentName)")
            return
        }
        
        db.collection(accountName).document(documentName).setData(
            dict
        ) { (error) in
            if let e = error {
                print("Error saving: \(e)")
            } else {
                print("Successfully Saved \(documentName)")
            }
        }
    }
    
}
