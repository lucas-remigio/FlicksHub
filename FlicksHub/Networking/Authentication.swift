//
//  Authentication.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//
import Foundation
import FirebaseAuth
import SwiftUI

class AuthenticationService {
    private let uidKey = "userUID"
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Using firebase to authenticate and retrieve the uid
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Login failed with error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = authResult?.user else {
                print("Login failed: No user found")
                completion(false)
                return
            }
            
            // Save UID in UserDefaults
            UserDefaults.standard.set(user.uid, forKey: self.uidKey)
            print("Login successful. UID: \(user.uid)")
            self.isUserLoggedIn = true
            completion(true)
        }
    }
    
    func register(username: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Registration failed with error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let user = authResult?.user else {
                print("Registration failed: No user found")
                completion(false)
                return
            }
            
            // Save UID in UserDefaults
            UserDefaults.standard.set(user.uid, forKey: self.uidKey)
            print("Registration successful. UID: \(user.uid)")
            self.isUserLoggedIn = true
            completion(true)
        }
    }
    
    // Method to log out the user and clear the UID from UserDefaults
    func logout(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: uidKey)
            print("User logged out and UID removed from UserDefaults.")
            self.isUserLoggedIn = false 
            completion(true)
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            completion(false)
        }
    }
    
    // Method to retrieve the saved UID (if needed)
    func getSavedUID() -> String? {
        return UserDefaults.standard.string(forKey: uidKey)
    }
    
    // Method to retrieve current user's profile info
    func getUserProfile(completion: @escaping (FirebaseAuth.User?) -> Void) {
        if let user = Auth.auth().currentUser {
            completion(user)
        } else {
            completion(nil)
        }
    }
    
}
