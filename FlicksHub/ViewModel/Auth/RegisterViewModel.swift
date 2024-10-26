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

    func register() {
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }
        authService.register(username: username, password: password) { [weak self] success in
            if success {
            } else {
                self?.errorMessage = "Invalid credentials. Please try again."
            }
        }
    }
}

