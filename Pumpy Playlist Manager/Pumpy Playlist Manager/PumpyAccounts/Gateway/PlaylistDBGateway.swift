//
//  LibraryAPIModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/03/2022.
//

import Foundation
import FirebaseFirestore
import CodableFirebase
import PumpyAnalytics

class PlaylistDBGateway {
    
    let db = Firestore.firestore()
    let username: String
    
    init(username: String) {
        self.username = username
    }
    
    func downloadPlaylists(completion: @escaping ([PlaylistSnapshot])->()) -> ListenerRegistration {
        let playlistsRef = db.collection(username).document(K.Fire.playlistLibrary)
        
        return playlistsRef.addSnapshotListener { documentSnapshot, err in
            
            guard let document = documentSnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            if let dataField = data[K.Fire.playlists] {
                do {
                    let decodedPlaylists = try FirebaseDecoder().decode([PlaylistSnapshot].self, from: dataField)
                    let libraryPlaylists = decodedPlaylists.sorted(by: { $0.name ?? "" < $1.name ?? "" })
                    completion(libraryPlaylists)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func addPlaylistToLibrary(playlist: PlaylistSnapshot) {
        let playlistsRef = db.collection(username).document(K.Fire.playlistLibrary)
        let dataPlaylist = try! FirestoreEncoder().encode(playlist)
        
        playlistsRef.updateData([
            K.Fire.playlists: FieldValue.arrayUnion([dataPlaylist])
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Playlist successfully added!")
            }
        }
    }
    
    func removePlaylistFromLibrary(playlist: PlaylistSnapshot) {
        let dataPlaylist = try! FirestoreEncoder().encode(playlist)
        
        let playlistsRef = db.collection(username).document(K.Fire.playlistLibrary)
        playlistsRef.updateData([
            K.Fire.playlists: FieldValue.arrayRemove([dataPlaylist])
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Playlist successfully removed!")
            }
        }
    }
    
    func updateSnapshot(oldSnapshot: PlaylistSnapshot, newSnapshot: PlaylistSnapshot) {
        let playlistsRef = db.collection(username).document(K.Fire.playlistLibrary)
        
        db.runTransaction { transaction, errorPointer in
            
            let newEncodedPlaylist = try! FirestoreEncoder().encode(newSnapshot)
            let oldEncodedPlaylist = try! FirestoreEncoder().encode(oldSnapshot)
            
            transaction.updateData([
                K.Fire.playlists: FieldValue.arrayUnion([newEncodedPlaylist])
            ], forDocument: playlistsRef)
            
            transaction.updateData([
                K.Fire.playlists: FieldValue.arrayRemove([oldEncodedPlaylist])
            ], forDocument: playlistsRef)
            
            return nil
        } completion: { object, error in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
        
    }
    
}
