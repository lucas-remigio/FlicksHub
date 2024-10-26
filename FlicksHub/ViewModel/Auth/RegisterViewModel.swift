//
//  LoginViewModel.swift
//  FlicksHub
//
//  Created by Lucas Remigio on 05/10/2024.
//

import Combine
import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    
    private var authService = AuthenticationService()

    func register(completion: @escaping (Bool) -> Void) {
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            completion(false)
            return
        }
        authService.register(username: username, password: password) { [weak self] success in
            if success {
                completion(true)
            } else {
                self?.errorMessage = "Invalid credentials. Please try again."
                completion(false)
            }
        }
    }
}

