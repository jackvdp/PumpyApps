//
//  Firebase.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 07/09/2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

public class FirebaseStore {
    
    private init() {}
    
    public static let shared = FirebaseStore()
    
    public var db: Firestore!
    
    public func configure() {
        FirebaseApp.configure()
        db = Firestore.firestore()
    }
    
    public func signIn(_ name: String, _ password: String, completion: @escaping (String?, Error?)->()) {
        Auth.auth().signIn(withEmail: name.lowercased(), password: password) { result, error in
        
            completion(result?.user.email, error)
        }
    }
    
    public func signUp(_ name: String, _ password: String, completion: @escaping (String?, Error?)->()) {
        Auth.auth().createUser(withEmail: name.lowercased(), password: password) { result, error in
            
            completion(result?.user.email, error)
        }
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    public func deleteAccount(completion: @escaping (Bool)->()) {
        Auth.auth().currentUser?.delete() { error in
            completion(error == nil)
        }
    }
    
    public func changePassword(newPassword: String,
                               completion: @escaping (Bool)->()) {
        
        Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { error in
            completion(error == nil)
        })
    }
    
}

public typealias FirebaseListener = ListenerRegistration
