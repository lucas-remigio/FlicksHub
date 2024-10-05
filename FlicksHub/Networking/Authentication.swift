//
//  Authentication.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//
import Foundation

class AuthenticationService {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        // Simulate a network call (e.g., 2 seconds delay)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if username == "test" && password == "password" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
