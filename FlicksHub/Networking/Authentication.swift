//
//  Authentication.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//
import Foundation
import FirebaseAuth

class AuthenticationService {
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
            
            print("Login successful. UID: \(user.uid)")
            completion(true)
        }
    }
}
